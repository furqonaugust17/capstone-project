import 'dart:math' as math;
import 'dart:typed_data';

import 'package:image/image.dart' as img;

import 'package:app/core/constants/app_constants.dart';
import 'package:app/core/ml/image_preprocessor.dart';
import 'package:app/core/ml/tensor_converter.dart';
import 'package:app/core/ml/tflite_service.dart';

import '../models/prediction_model.dart';

class ClassificationException implements Exception {
  final String message;
  final Object? cause;

  const ClassificationException(this.message, {this.cause});

  @override
  String toString() =>
      'ClassificationException(message: $message, cause: $cause)';
}

abstract class TFLiteLocalDataSource {
  Future<void> warmUpModel();

  Future<PredictionModel> classifySketch(
    Uint8List imageBytes, {
    bool? forceGrayscale,
    bool isRawRgba = false,
    int? width,
    int? height,
  });
}

class TFLiteLocalDataSourceImpl implements TFLiteLocalDataSource {
  final TFLiteService _tfliteService;
  final ImagePreprocessor _preprocessor;
  final TensorConverter _tensorConverter;

  const TFLiteLocalDataSourceImpl({
    required TFLiteService tfliteService,
    required ImagePreprocessor preprocessor,
    required TensorConverter tensorConverter,
  }) : _tfliteService = tfliteService,
       _preprocessor = preprocessor,
       _tensorConverter = tensorConverter;

  @override
  Future<void> warmUpModel() async {
    await _tfliteService.init();
  }

  @override
  Future<PredictionModel> classifySketch(
    Uint8List imageBytes, {
    bool? forceGrayscale,
    bool isRawRgba = false,
    int? width,
    int? height,
  }) async {
    if (imageBytes.isEmpty) {
      throw const ClassificationException('Image input is empty.');
    }

    try {
      await _tfliteService.init();

      final modelWidth = _tfliteService.resolveInputWidth();
      final modelHeight = _tfliteService.resolveInputHeight();
      final channels = _resolveImageChannels(
        width: modelWidth,
        height: modelHeight,
      );
      final grayscale = forceGrayscale ?? channels == 1;

      // Determine if incoming bytes are raw RGBA.
      final srcWidth = width;
      final srcHeight = height;
      try {
        print(
          'TFLiteLocalDataSource.classifySketch: imageBytes=${imageBytes.length}, srcWidth=${srcWidth ?? 'null'}, srcHeight=${srcHeight ?? 'null'}, modelWxH=${modelWidth}x${modelHeight}, isRawRgba=$isRawRgba',
        );
      } catch (_) {}
      final likelyRawRgba =
          isRawRgba ||
          (srcWidth != null &&
              srcHeight != null &&
              imageBytes.length == srcWidth * srcHeight * 4);

      img.Image processed;
      if (likelyRawRgba) {
        try {
          print(
            'TFLiteLocalDataSource: using preprocessFromRgba (likely raw RGBA)',
          );
        } catch (_) {}
        processed = _preprocessor.preprocessFromRgba(
          imageBytes,
          width: srcWidth ?? modelWidth,
          height: srcHeight ?? modelHeight,
          targetWidth: modelWidth,
          targetHeight: modelHeight,
          grayscale: grayscale,
        );
      } else {
        try {
          processed = _preprocessor.preprocess(
            imageBytes,
            targetWidth: modelWidth,
            targetHeight: modelHeight,
            grayscale: grayscale,
          );
        } on ImagePreprocessorException catch (err) {
          try {
            print(
              'TFLiteLocalDataSource: PNG decode failed: ${err.toString()}',
            );
          } catch (_) {}
          // If decode failed, attempt to infer raw-RGBA dimensions and retry.
          final len = imageBytes.length;
          if (len % 4 == 0) {
            final pixels = len ~/ 4;
            var inferredWidth = srcWidth;
            var inferredHeight = srcHeight;

            // Prefer the provided src dims if they match byte length
            if (inferredWidth != null && inferredHeight != null) {
              if (inferredWidth * inferredHeight != pixels) {
                inferredWidth = null;
                inferredHeight = null;
              }
            }

            // If no provided dims, check if bytes match model dims
            if (inferredWidth == null && inferredHeight == null) {
              if (pixels == modelWidth * modelHeight) {
                inferredWidth = modelWidth;
                inferredHeight = modelHeight;
              } else {
                final sqrtP = (math.sqrt(pixels)).round();
                if (sqrtP * sqrtP == pixels) {
                  inferredWidth = sqrtP;
                  inferredHeight = sqrtP;
                }
              }
            }

            if (inferredWidth != null && inferredHeight != null) {
              try {
                print(
                  'TFLiteLocalDataSource: falling back to preprocessFromRgba with inferred ${inferredWidth}x${inferredHeight}',
                );
              } catch (_) {}
              processed = _preprocessor.preprocessFromRgba(
                imageBytes,
                width: inferredWidth,
                height: inferredHeight,
                targetWidth: modelWidth,
                targetHeight: modelHeight,
                grayscale: grayscale,
              );
            } else {
              rethrow;
            }
          } else {
            rethrow;
          }
        }
      }

      final normalizedTensor = _tensorConverter.toFloat32(
        processed,
        channels: channels,
        mean: AppConstants.defaultNormalizationMean,
        std: AppConstants.defaultNormalizationStd,
      );

      final shapedInput = _tensorConverter.toInterpreterInputForShape(
        normalizedTensor,
        width: modelWidth,
        height: modelHeight,
        channels: channels,
        inputShape: _tfliteService.inputShape,
      );

      final output = _tfliteService.runInference(
        inputTensor: shapedInput,
        outputLength: _tfliteService.resolveOutputClasses(),
      );

      if (output.scores.isEmpty) {
        throw const ClassificationException(
          'Model produced empty prediction scores.',
        );
      }

      final bestIndex = _findBestIndex(output.scores);
      final labels = _tfliteService.labels;

      // Debug: print raw scores and per-class breakdown for diagnosis.
      try {
        final scoreMap = <String, String>{};
        for (var i = 0; i < output.scores.length && i < labels.length; i++) {
          scoreMap[labels[i]] =
              (output.scores[i] * 100).toStringAsFixed(1) + '%';
        }
        print(
          'TFLiteLocalDataSource: rawScores=${output.scores}, '
          'breakdown=$scoreMap, '
          'inference=${output.duration.inMilliseconds}ms',
        );
      } catch (_) {}

      if (labels.isEmpty) {
        throw const ClassificationException(
          'Labels are missing or failed to load.',
        );
      }

      if (bestIndex >= labels.length) {
        throw ClassificationException(
          'Predicted index $bestIndex is out of labels range (${labels.length}).',
        );
      }

      final confidence = output.scores[bestIndex].clamp(0.0, 1.0);

      return PredictionModel(
        label: labels[bestIndex],
        confidence: confidence,
        rawScores: output.scores,
        inferenceDuration: output.duration,
      );
    } on TFLiteServiceException catch (error) {
      throw ClassificationException(
        'TensorFlow Lite operation failed.',
        cause: error,
      );
    } on ImagePreprocessorException catch (error) {
      throw ClassificationException(
        'Image preprocessing failed.',
        cause: error,
      );
    } on TensorConverterException catch (error) {
      throw ClassificationException('Tensor conversion failed.', cause: error);
    } on ClassificationException {
      rethrow;
    } catch (error) {
      throw ClassificationException(
        'Unexpected classification failure.',
        cause: error,
      );
    }
  }

  int _findBestIndex(List<double> scores) {
    var bestIndex = 0;
    var bestScore = -double.infinity;

    for (var i = 0; i < scores.length; i++) {
      final score = scores[i];
      if (score > bestScore) {
        bestScore = score;
        bestIndex = i;
      }
    }

    return math.max(bestIndex, 0);
  }

  int _resolveImageChannels({required int width, required int height}) {
    final inputShape = _tfliteService.inputShape;

    if (inputShape.length >= 4) {
      final channels = inputShape.last;
      if (channels == 1 || channels == 3) {
        return channels;
      }
    }

    if (inputShape.length == 2 && inputShape[1] > 0) {
      final flattened = inputShape[1];
      final pixels = width * height;
      if (pixels > 0 && flattened % pixels == 0) {
        final channels = flattened ~/ pixels;
        if (channels == 1 || channels == 3) {
          return channels;
        }
      }
    }

    return AppConstants.defaultInputChannels;
  }
}
