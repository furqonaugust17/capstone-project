import '../../domain/entities/prediction_entity.dart';

class PredictionModel extends PredictionEntity {
  const PredictionModel({
    required super.label,
    required super.confidence,
    required super.rawScores,
    required super.inferenceDuration,
  });

  factory PredictionModel.fromEntity(PredictionEntity entity) {
    return PredictionModel(
      label: entity.label,
      confidence: entity.confidence,
      rawScores: entity.rawScores,
      inferenceDuration: entity.inferenceDuration,
    );
  }

  PredictionEntity toEntity() {
    return PredictionEntity(
      label: label,
      confidence: confidence,
      rawScores: rawScores,
      inferenceDuration: inferenceDuration,
    );
  }
}
