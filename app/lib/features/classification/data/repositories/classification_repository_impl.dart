import 'dart:typed_data';

import '../../domain/entities/prediction_entity.dart';
import '../../domain/repositories/classification_repository.dart';
import '../datasources/tflite_local_data_source.dart';

class ClassificationRepositoryImpl implements ClassificationRepository {
  final TFLiteLocalDataSource _localDataSource;

  const ClassificationRepositoryImpl(this._localDataSource);

  @override
  Future<void> warmUpModel() {
    return _localDataSource.warmUpModel();
  }

  @override
  Future<PredictionEntity> classifySketch(
    Uint8List imageBytes, {
    bool? forceGrayscale,
    bool isRawRgba = false,
    int? width,
    int? height,
  }) {
    return _localDataSource.classifySketch(
      imageBytes,
      forceGrayscale: forceGrayscale,
      isRawRgba: isRawRgba,
      width: width,
      height: height,
    );
  }
}
