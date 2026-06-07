import 'dart:typed_data';

import 'package:image/image.dart' as img;

class ImagePreprocessorException implements Exception {
  final String message;
  final Object? cause;

  const ImagePreprocessorException(this.message, {this.cause});

  @override
  String toString() =>
      'ImagePreprocessorException(message: $message, cause: $cause)';
}

class ImagePreprocessor {
  const ImagePreprocessor();

  img.Image decodeImage(Uint8List bytes) {
    // Debug: log incoming bytes length to help diagnose decode failures.
    try {
      print('ImagePreprocessor.decodeImage: incoming bytes=${bytes.length}');
    } catch (_) {}

    final image = img.decodeImage(bytes);
    if (image == null) {
      throw const ImagePreprocessorException(
        'Invalid image input. Could not decode image bytes.',
      );
    }
    return image;
  }

  /// Crops the drawing region by detecting **foreground strokes** against
  /// a known [backgroundColor].
  ///
  /// Instead of using alpha (which is 255 for both background and strokes
  /// on an opaque canvas like SfSignaturePad), this compares each pixel's
  /// RGB values against the background color and considers a pixel as
  /// "drawn" if it differs by more than [colorThreshold].
  img.Image cropToDrawing(
    img.Image source, {
    int backgroundR = 0xF7,
    int backgroundG = 0xF9,
    int backgroundB = 0xFC,
    int colorThreshold = 30,
    int padding = 10,
  }) {
    var minX = source.width;
    var minY = source.height;
    var maxX = -1;
    var maxY = -1;

    for (var y = 0; y < source.height; y++) {
      for (var x = 0; x < source.width; x++) {
        final pixel = source.getPixel(x, y);
        final dr = (pixel.r.toInt() - backgroundR).abs();
        final dg = (pixel.g.toInt() - backgroundG).abs();
        final db = (pixel.b.toInt() - backgroundB).abs();
        final diff = dr + dg + db;

        if (diff > colorThreshold) {
          if (x < minX) minX = x;
          if (y < minY) minY = y;
          if (x > maxX) maxX = x;
          if (y > maxY) maxY = y;
        }
      }
    }

    if (maxX < minX || maxY < minY) {
      throw const ImagePreprocessorException(
        'Image contains no drawable pixels after foreground scan.',
      );
    }

    // Add padding around the crop, clamped to image bounds.
    minX = (minX - padding).clamp(0, source.width - 1);
    minY = (minY - padding).clamp(0, source.height - 1);
    maxX = (maxX + padding).clamp(0, source.width - 1);
    maxY = (maxY + padding).clamp(0, source.height - 1);

    try {
      print(
        'ImagePreprocessor.cropToDrawing: '
        'crop=($minX,$minY)-($maxX,$maxY) from ${source.width}x${source.height}',
      );
    } catch (_) {}

    return img.copyCrop(
      source,
      x: minX,
      y: minY,
      width: maxX - minX + 1,
      height: maxY - minY + 1,
    );
  }

  /// Centers the source image inside a square canvas filled with
  /// a solid [backgroundColor] (default: white).
  img.Image centerToSquare(
    img.Image source, {
    img.Color? backgroundColor,
  }) {
    final bg = backgroundColor ?? img.ColorRgba8(255, 255, 255, 255);
    final size = source.width > source.height ? source.width : source.height;
    final square = img.Image(width: size, height: size);
    img.fill(square, color: bg);

    final offsetX = ((size - source.width) / 2).round();
    final offsetY = ((size - source.height) / 2).round();

    img.compositeImage(square, source, dstX: offsetX, dstY: offsetY);
    return square;
  }

  img.Image resize(
    img.Image source, {
    required int width,
    required int height,
  }) {
    if (width <= 0 || height <= 0) {
      throw ImagePreprocessorException(
        'Invalid resize target. Width and height must be > 0. '
        'Received width=$width, height=$height.',
      );
    }

    return img.copyResize(
      source,
      width: width,
      height: height,
      interpolation: img.Interpolation.average,
    );
  }

  img.Image toGrayscaleIfNeeded(img.Image source, {required bool enabled}) {
    if (!enabled) return source;
    return img.grayscale(source);
  }

  /// Replaces the background color of the canvas with white, so that
  /// the model receives an image consistent with training data
  /// (dark strokes on white background).
  img.Image replaceBackgroundWithWhite(
    img.Image source, {
    int backgroundR = 0xF7,
    int backgroundG = 0xF9,
    int backgroundB = 0xFC,
    int colorThreshold = 30,
  }) {
    final result = img.Image.from(source);
    for (var y = 0; y < result.height; y++) {
      for (var x = 0; x < result.width; x++) {
        final pixel = result.getPixel(x, y);
        final dr = (pixel.r.toInt() - backgroundR).abs();
        final dg = (pixel.g.toInt() - backgroundG).abs();
        final db = (pixel.b.toInt() - backgroundB).abs();
        final diff = dr + dg + db;

        if (diff <= colorThreshold) {
          // This pixel is background — replace with white
          result.setPixelRgba(x, y, 255, 255, 255, 255);
        }
      }
    }
    return result;
  }

  img.Image preprocess(
    Uint8List imageBytes, {
    required int targetWidth,
    required int targetHeight,
    required bool grayscale,
    int alphaThreshold = 8,
  }) {
    try {
      final decoded = decodeImage(imageBytes);
      final whiteBackground = replaceBackgroundWithWhite(decoded);
      final cropped = cropToDrawing(whiteBackground);
      final centered = centerToSquare(cropped);
      final resized = resize(
        centered,
        width: targetWidth,
        height: targetHeight,
      );
      return toGrayscaleIfNeeded(resized, enabled: grayscale);
    } on ImagePreprocessorException {
      rethrow;
    } catch (error) {
      throw ImagePreprocessorException('Preprocessing failed.', cause: error);
    }
  }

  /// Preprocess when raw RGBA bytes and explicit size are available.
  img.Image preprocessFromRgba(
    Uint8List rgbaBytes, {
    required int width,
    required int height,
    required int targetWidth,
    required int targetHeight,
    required bool grayscale,
    int alphaThreshold = 8,
  }) {
    try {
      try {
        print(
          'ImagePreprocessor.preprocessFromRgba: rgbaBytes=${rgbaBytes.length}, width=$width, height=$height',
        );
      } catch (_) {}
      // package:image expects raw bytes as a List<int> with 4 channels (RGBA)
      final decoded = img.Image.fromBytes(
        width: width,
        height: height,
        bytes: rgbaBytes.buffer,
      );

      // 1. Replace the canvas background (0xFFF7F9FC) with pure white
      //    so the model sees dark strokes on white background.
      final whiteBackground = replaceBackgroundWithWhite(decoded);

      // 2. Crop to just the drawing region (foreground strokes)
      final cropped = cropToDrawing(whiteBackground);

      // 3. Center the cropped drawing inside a white square
      final centered = centerToSquare(cropped);

      // 4. Resize to model input dimensions
      final resized = resize(
        centered,
        width: targetWidth,
        height: targetHeight,
      );

      // 5. Apply grayscale if the model expects single-channel input
      return toGrayscaleIfNeeded(resized, enabled: grayscale);
    } on ImagePreprocessorException {
      rethrow;
    } catch (error) {
      throw ImagePreprocessorException(
        'Preprocessing failed (raw RGBA).',
        cause: error,
      );
    }
  }
}
