import 'dart:typed_data';

import '../entities/prediction_entity.dart';

abstract class ClassificationRepository {
  Future<void> warmUpModel();

  Future<PredictionEntity> classifySketch(
    Uint8List imageBytes, {
    bool? forceGrayscale,
    bool isRawRgba = false,
    int? width,
    int? height,
  });
}
