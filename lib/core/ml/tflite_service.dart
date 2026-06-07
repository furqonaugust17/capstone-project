import 'dart:typed_data';
import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import '../constants/app_constants.dart';

class TFLiteServiceException implements Exception {
  final String message;
  final Object? cause;

  const TFLiteServiceException(this.message, {this.cause});

  @override
  String toString() =>
      'TFLiteServiceException(message: $message, cause: $cause)';
}

class InferenceOutput {
  final List<double> scores;
  final Duration duration;

  const InferenceOutput({required this.scores, required this.duration});
}

class TFLiteService {
  final String modelAssetPath;
  final String labelsAssetPath;
  final int threads;

  Interpreter? _interpreter;
  bool _isInitialized = false;
  List<String> _labels = const <String>[];

  TFLiteService({
    this.modelAssetPath = AppConstants.modelAssetPath,
    this.labelsAssetPath = AppConstants.labelsAssetPath,
    this.threads = 2,
  });

  bool get isInitialized => _isInitialized && _interpreter != null;
  List<String> get labels => List<String>.unmodifiable(_labels);

  List<int> get inputShape {
    final interpreter = _requireInterpreter();
    return List<int>.from(interpreter.getInputTensor(0).shape);
  }

  List<int> get outputShape {
    final interpreter = _requireInterpreter();
    return List<int>.from(interpreter.getOutputTensor(0).shape);
  }

  Future<void> init() async {
    if (isInitialized) return;

    try {
      final options = InterpreterOptions()..threads = threads;
      final modelData = await rootBundle.load(modelAssetPath);
      final modelBytes = modelData.buffer.asUint8List();

      if (modelBytes.isEmpty) {
        throw const TFLiteServiceException(
          'Model asset was loaded but contains no bytes.',
        );
      }

      _interpreter = Interpreter.fromBuffer(modelBytes, options: options);
      _labels = await _loadLabels(labelsAssetPath);
      _isInitialized = true;

      // Debug: print model tensor shapes on startup for diagnosis.
      try {
        print('TFLiteService.init: inputShape=$inputShape, outputShape=$outputShape');
      } catch (_) {}
    } on PlatformException catch (error) {
      throw TFLiteServiceException(
        'Interpreter initialization failed.',
        cause: error,
      );
    } catch (error) {
      throw TFLiteServiceException(
        'Unexpected error during TFLite initialization.',
        cause: error,
      );
    }
  }

  Future<List<String>> _loadLabels(String path) async {
    final raw = await rootBundle.loadString(path);
    final lines = raw
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList(growable: false);

    if (lines.isEmpty) {
      throw const TFLiteServiceException(
        'Labels file is empty. At least one label is required.',
      );
    }

    return lines;
  }

  InferenceOutput runInference({
    required Object inputTensor,
    int? outputLength,
  }) {
    final interpreter = _requireInterpreter();

    final outputTensorShape = outputShape;
    if (outputTensorShape.isEmpty) {
      throw const TFLiteServiceException(
        'Output tensor shape resolved to empty output.',
      );
    }

    // ── Compute total element counts ──
    final inputTensorShape = inputShape;
    var inputElements = 1;
    for (final d in inputTensorShape) {
      inputElements *= d;
    }
    var outputElements = 1;
    for (final d in outputTensorShape) {
      outputElements *= d;
    }

    // ── Flatten the input into a raw ByteBuffer ──
    // The interpreter's setTo() has a fast path for Uint8List / ByteBuffer
    // that avoids all the nested-list type juggling which causes
    // "List<double> is not a subtype of Float32List" errors.
    final Float32List flatInput;
    if (inputTensor is Float32List) {
      flatInput = inputTensor;
    } else if (inputTensor is List) {
      flatInput = Float32List(inputElements);
      var idx = 0;
      void flatten(dynamic v) {
        if (v is Float32List) {
          flatInput.setRange(idx, idx + v.length, v);
          idx += v.length;
        } else if (v is List) {
          for (final e in v) {
            flatten(e);
          }
        } else if (v is num) {
          flatInput[idx++] = v.toDouble();
        }
      }
      flatten(inputTensor);
    } else {
      throw TFLiteServiceException(
        'Unsupported input tensor type: ${inputTensor.runtimeType}.',
      );
    }

    if (flatInput.length != inputElements) {
      throw TFLiteServiceException(
        'Input element count mismatch. '
        'Expected $inputElements for shape $inputTensorShape, '
        'got ${flatInput.length}.',
      );
    }

    // Use the raw byte buffer so the interpreter copies bytes directly
    // via TfLiteTensorCopyFromBuffer (no Dart list type conversion).
    final inputBytes = flatInput.buffer.asUint8List();

    // ── Prepare output buffer as raw bytes ──
    final outputBytes = Uint8List(outputElements * 4); // float32 = 4 bytes

    // Debug logging.
    try {
      print(
        'TFLiteService.runInference: '
        'inputElements=$inputElements, '
        'outputElements=$outputElements, '
        'expectedInputShape=$inputTensorShape',
      );
    } catch (_) {}

    final stopwatch = Stopwatch()..start();

    try {
      interpreter.run(inputBytes, outputBytes);
      stopwatch.stop();

      // Decode output bytes back to float32 scores.
      final outputFloats = outputBytes.buffer.asFloat32List();
      final scores = List<double>.generate(
        outputFloats.length,
        (i) => outputFloats[i].toDouble(),
        growable: false,
      );

      return InferenceOutput(
        scores: scores,
        duration: stopwatch.elapsed,
      );
    } on ArgumentError catch (error) {
      throw TFLiteServiceException(
        'Tensor shape mismatch. Ensure input dimensions match model input tensor.',
        cause: error,
      );
    } catch (error) {
      throw TFLiteServiceException('Unexpected inference error.', cause: error);
    }
  }

  int resolveInputWidth({int fallback = AppConstants.defaultInputSize}) {
    final shape = inputShape;
    return shape.length >= 3 ? shape[1] : fallback;
  }

  int resolveInputHeight({int fallback = AppConstants.defaultInputSize}) {
    final shape = inputShape;
    return shape.length >= 3 ? shape[2] : fallback;
  }

  int resolveInputChannels({int fallback = AppConstants.defaultInputChannels}) {
    final shape = inputShape;
    return shape.isNotEmpty ? shape.last : fallback;
  }

  int resolveOutputClasses({int fallback = AppConstants.defaultOutputClasses}) {
    final shape = outputShape;
    if (shape.isEmpty) return fallback;
    return math.max(1, shape.last);
  }

  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _isInitialized = false;
  }

  Object _createOutputBuffer(List<int> shape) {
    if (shape.length == 1) {
      return Float32List(shape.first);
    }

    if (shape.length == 2) {
      return List.generate(
        shape[0],
        (_) => Float32List(shape[1]),
        growable: false,
      );
    }

    if (shape.length == 3) {
      return List.generate(
        shape[0],
        (_) => List.generate(
          shape[1],
          (_) => Float32List(shape[2]),
          growable: false,
        ),
        growable: false,
      );
    }

    if (shape.length == 4) {
      return List.generate(
        shape[0],
        (_) => List.generate(
          shape[1],
          (_) => List.generate(
            shape[2],
            (_) => Float32List(shape[3]),
            growable: false,
          ),
          growable: false,
        ),
        growable: false,
      );
    }

    throw TFLiteServiceException(
      'Unsupported output tensor rank: ${shape.length}.',
    );
  }

  List<double> _flattenOutput(Object output) {
    final scores = <double>[];

    void visit(dynamic value) {
      if (value is num) {
        scores.add(value.toDouble());
        return;
      }

      if (value is Iterable) {
        for (final item in value) {
          visit(item);
        }
        return;
      }

      throw TFLiteServiceException(
        'Unexpected output type from interpreter: ${value.runtimeType}.',
      );
    }

    visit(output);
    return scores;
  }

  Interpreter _requireInterpreter() {
    final interpreter = _interpreter;
    if (interpreter == null) {
      throw const TFLiteServiceException(
        'Interpreter is not initialized. Call init() before inference.',
      );
    }
    return interpreter;
  }
}
