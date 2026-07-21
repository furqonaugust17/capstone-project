import 'dart:typed_data';

import '../entities/prediction_entity.dart';
import '../repositories/classification_repository.dart';

class ClassifySketchUseCase {
  final ClassificationRepository _repository;

  const ClassifySketchUseCase(this._repository);

  Future<PredictionEntity> call(ClassifySketchParams params) {
    return _repository.classifySketch(
      params.imageBytes,
      forceGrayscale: params.forceGrayscale,
      isRawRgba: params.isRawRgba,
      width: params.width,
      height: params.height,
    );
  }

  Future<void> warmUpModel() => _repository.warmUpModel();
}

class ClassifySketchParams {
  final Uint8List imageBytes;
  final bool? forceGrayscale;
  final bool isRawRgba;
  final int? width;
  final int? height;

  const ClassifySketchParams({
    required this.imageBytes,
    this.forceGrayscale,
    this.isRawRgba = false,
    this.width,
    this.height,
  });
}
