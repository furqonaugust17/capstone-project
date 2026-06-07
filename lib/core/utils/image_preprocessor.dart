import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:image/image.dart' as img;

/// Manual preprocessing pipeline used before TFLite inference.
///
/// This replaces the discontinued `tflite_flutter_helper` package.
/// It converts a canvas [ui.Image] into normalized grayscale tensor data.
///
/// Pipeline:
/// 1. Convert canvas to image
/// 2. Crop unnecessary whitespace
/// 3. Center the drawing
/// 4. Resize image to model input size
/// 5. Convert to grayscale
/// 6. Normalize pixel values
/// 7. Convert to flat tensor data
class ImagePreprocessor {
  final int targetWidth;
  final int targetHeight;
  final int channels;

  ImagePreprocessor({
    required this.targetWidth,
    required this.targetHeight,
    this.channels = 1,
  });

  Future<Float32List> preprocess(ui.Image image) async {
    final decoded = await _uiImageToImg(image);
    if (decoded == null) {
      throw Exception('Failed to decode ui.Image to package:image Image');
    }

    final cropped = _cropTransparentWhitespace(decoded);
    final centered = _centerOnSquareCanvas(cropped);
    final resized = img.copyResize(
      centered,
      width: targetWidth,
      height: targetHeight,
      interpolation: img.Interpolation.linear,
    );
    final gray = img.grayscale(resized);

    return _toNormalizedFloat32(gray);
  }

  Future<img.Image?> _uiImageToImg(ui.Image uiImage) async {
    final byteData = await uiImage.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return null;
    final bytes = byteData.buffer.asUint8List();
    return img.decodeImage(bytes);
  }

  img.Image _cropTransparentWhitespace(img.Image source) {
    var minX = source.width;
    var minY = source.height;
    var maxX = -1;
    var maxY = -1;

    for (var y = 0; y < source.height; y++) {
      for (var x = 0; x < source.width; x++) {
        final pixel = source.getPixel(x, y);
        if (pixel.a > 0) {
          if (x < minX) minX = x;
          if (y < minY) minY = y;
          if (x > maxX) maxX = x;
          if (y > maxY) maxY = y;
        }
      }
    }

    if (maxX < minX || maxY < minY) {
      return source;
    }

    return img.copyCrop(
      source,
      x: minX,
      y: minY,
      width: maxX - minX + 1,
      height: maxY - minY + 1,
    );
  }

  img.Image _centerOnSquareCanvas(img.Image source) {
    final size = source.width > source.height ? source.width : source.height;
    final canvas = img.Image(width: size, height: size);
    img.fill(canvas, color: img.ColorRgba8(0, 0, 0, 0));

    final offsetX = ((size - source.width) / 2).round();
    final offsetY = ((size - source.height) / 2).round();
    img.compositeImage(canvas, source, dstX: offsetX, dstY: offsetY);
    return canvas;
  }

  Float32List _toNormalizedFloat32(img.Image source) {
    final pixelCount = targetWidth * targetHeight * channels;
    final buffer = Float32List(pixelCount);
    var index = 0;

    for (var y = 0; y < source.height; y++) {
      for (var x = 0; x < source.width; x++) {
        final pixel = source.getPixel(x, y);
        final r = pixel.r.toDouble();
        final g = pixel.g.toDouble();
        final b = pixel.b.toDouble();
        final normalized = ((r + g + b) / 3.0) / 255.0;

        if (channels == 1) {
          buffer[index++] = normalized;
        } else {
          for (var c = 0; c < channels; c++) {
            buffer[index++] = normalized;
          }
        }
      }
    }

    return buffer;
  }
}
