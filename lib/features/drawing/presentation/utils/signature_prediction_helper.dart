import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

import 'package:app/core/ml/tflite_service.dart';
import 'package:app/core/ml/tensor_converter.dart';
import 'package:app/injection/injection.dart';
import 'package:image/image.dart' as img;
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

// image_preprocessor not required here

/// Helper utilities to capture a SignaturePad, preprocess and predict.
class SignaturePredictionHelper {
  const SignaturePredictionHelper._();

  static Future<Uint8List> signatureToPngImage(
    GlobalKey<SfSignaturePadState> signatureKey, {
    double pixelRatio = 1.0,
  }) async {
    final state = signatureKey.currentState;
    if (state == null) throw Exception('SignaturePad state is null');

    final ui.Image image = await state.toImage(pixelRatio: pixelRatio);
    final ByteData? byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    final Uint8List pngBytes = byteData!.buffer.asUint8List();

    // decode/encode to normalize PNG structure via package:image (optional)
    final img.Image? imgData = img.decodeImage(pngBytes);
    final Uint8List finalPngBytes = img.encodePng(imgData!);

    return finalPngBytes;
  }

  /// Preprocess signature into a normalized Float32List ready for model input.
  /// Returns a Float32List of length [targetWidth * targetHeight].
  static Future<Float32List> preprocessSignatureToTensor(
    GlobalKey<SfSignaturePadState> signatureKey, {
    int targetWidth = 28,
    int targetHeight = 28,
  }) async {
    final pngBytes = await signatureToPngImage(signatureKey);
    final img.Image? imgData = img.decodeImage(pngBytes);
    if (imgData == null) throw Exception('Failed to decode signature PNG');

    final img.Image resized = img.copyResize(
      imgData,
      width: targetWidth,
      height: targetHeight,
      interpolation: img.Interpolation.average,
    );
    final img.Image gray = img.grayscale(resized);

    final length = targetWidth * targetHeight;
    final buffer = Float32List(length);

    var idx = 0;
    for (var y = 0; y < targetHeight; y++) {
      for (var x = 0; x < targetWidth; x++) {
        final pixel = gray.getPixel(x, y);
        final int r = pixel.r.toInt();
        buffer[idx++] = r / 255.0;
      }
    }

    return buffer;
  }

  /// Preprocess signature and return raw grayscale bytes (0..255) sized targetWidth*targetHeight.
  static Future<Uint8List> preprocessSignatureToGrayscaleBytes(
    GlobalKey<SfSignaturePadState> signatureKey, {
    int targetWidth = 28,
    int targetHeight = 28,
  }) async {
    final pngBytes = await signatureToPngImage(signatureKey);
    final img.Image? imgData = img.decodeImage(pngBytes);
    if (imgData == null) throw Exception('Failed to decode signature PNG');

    final img.Image resized = img.copyResize(
      imgData,
      width: targetWidth,
      height: targetHeight,
      interpolation: img.Interpolation.average,
    );
    final img.Image gray = img.grayscale(resized);

    final out = Uint8List(targetWidth * targetHeight);
    var idx = 0;
    for (var y = 0; y < targetHeight; y++) {
      for (var x = 0; x < targetWidth; x++) {
        final pixel = gray.getPixel(x, y);
        final int r = pixel.r.toInt();
        out[idx++] = r;
      }
    }

    return out;
  }

  /// Run prediction given grayscale bytes (0..255) matching targetWidth*targetHeight.
  static Future<List<double>> predictFromGrayscaleBytes(
    Uint8List grayscaleBytes, {
    int targetWidth = 28,
    int targetHeight = 28,
  }) async {
    if (grayscaleBytes.length != targetWidth * targetHeight) {
      throw Exception(
        'grayscaleBytes length mismatch. Expected ${targetWidth * targetHeight}, got ${grayscaleBytes.length}',
      );
    }

    final tflite = di<TFLiteService>();
    final converter = di<TensorConverter>();

    final length = targetWidth * targetHeight;
    final input = Float32List(length);
    for (var i = 0; i < length; i++) {
      input[i] = grayscaleBytes[i] / 255.0;
    }

    final shaped = converter.toInterpreterInputForShape(
      input,
      width: targetWidth,
      height: targetHeight,
      channels: 1,
      inputShape: tflite.inputShape,
    );

    final out = tflite.runInference(inputTensor: shaped);
    return out.scores;
  }

  /// Run prediction using the shared TFLiteService and TensorConverter.
  /// Returns the list of scores (flattened) from the model.
  static Future<List<double>> predictFromSignature(
    GlobalKey<SfSignaturePadState> signatureKey, {
    int targetWidth = 28,
    int targetHeight = 28,
  }) async {
    final tflite = di<TFLiteService>();
    final converter = di<TensorConverter>();

    final inputFlat = await preprocessSignatureToTensor(
      signatureKey,
      targetWidth: targetWidth,
      targetHeight: targetHeight,
    );

    // convert flat tensor to shaped interpreter input according to model
    final shaped = converter.toInterpreterInputForShape(
      inputFlat,
      width: targetWidth,
      height: targetHeight,
      channels: 1,
      inputShape: tflite.inputShape,
    );

    final out = tflite.runInference(inputTensor: shaped);
    return out.scores;
  }
}
