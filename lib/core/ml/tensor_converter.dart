import 'dart:typed_data';

import 'package:image/image.dart' as img;

class TensorConverterException implements Exception {
  final String message;
  final Object? cause;

  const TensorConverterException(this.message, {this.cause});

  @override
  String toString() =>
      'TensorConverterException(message: $message, cause: $cause)';
}

class TensorConverter {
  const TensorConverter();

  Float32List toFloat32(
    img.Image image, {
    required int channels,
    required double mean,
    required double std,
  }) {
    if (channels != 1 && channels != 3) {
      throw TensorConverterException(
        'Unsupported channel count: $channels. Supported values: 1 or 3.',
      );
    }

    if (std == 0) {
      throw const TensorConverterException('Normalization std cannot be zero.');
    }

    final pixelCount = image.width * image.height;
    final result = Float32List(pixelCount * channels);
    var index = 0;

    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);
        final r = _normalize(pixel.r.toDouble(), mean: mean, std: std);
        final g = _normalize(pixel.g.toDouble(), mean: mean, std: std);
        final b = _normalize(pixel.b.toDouble(), mean: mean, std: std);

        if (channels == 1) {
          result[index++] = (r + g + b) / 3.0;
        } else {
          result[index++] = r;
          result[index++] = g;
          result[index++] = b;
        }
      }
    }

    return result;
  }

  Float32List toInterpreterInput(
    Float32List data, {
    required int width,
    required int height,
    required int channels,
  }) {
    final expectedLength = width * height * channels;
    if (data.length != expectedLength) {
      throw TensorConverterException(
        'Tensor length mismatch. Expected $expectedLength, got ${data.length}.',
      );
    }

    return data;
  }

  /// Validates and returns the flat [Float32List] for interpreter consumption.
  ///
  /// The [TFLiteService.runInference] method now handles converting the flat
  /// buffer to raw bytes (`Uint8List`) before passing to the interpreter,
  /// bypassing all the problematic nested-list type conversion in the
  /// `tflite_flutter` package. Therefore this method only needs to validate
  /// that the element count matches the model's expected input shape.
  Object toInterpreterInputForShape(
    Float32List data, {
    required int width,
    required int height,
    required int channels,
    required List<int> inputShape,
  }) {
    final expectedLength = width * height * channels;
    if (data.length != expectedLength) {
      throw TensorConverterException(
        'Tensor length mismatch. Expected $expectedLength, got ${data.length}.',
      );
    }

    // Verify total element count matches the model's input shape.
    var shapeTotal = 1;
    for (final d in inputShape) {
      shapeTotal *= d;
    }
    if (data.length != shapeTotal) {
      throw TensorConverterException(
        'Data length ${data.length} does not match input shape '
        'total $shapeTotal ($inputShape).',
      );
    }

    try {
      print(
        'TensorConverter.toInterpreterInputForShape: '
        'validated ${data.length} elements for shape $inputShape',
      );
    } catch (_) {}

    // Return the flat Float32List — runInference converts to ByteBuffer.
    return data;
  }

  double _normalize(double value, {required double mean, required double std}) {
    return (value - mean) / std;
  }
}
