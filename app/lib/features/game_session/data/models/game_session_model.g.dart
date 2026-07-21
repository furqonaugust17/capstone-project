// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameSessionAnimalModel _$GameSessionAnimalModelFromJson(
  Map<String, dynamic> json,
) => GameSessionAnimalModel(
  id: json['id'] as String,
  name: json['name'] as String,
  thumbnailUrl: json['thumbnailUrl'] as String?,
);

Map<String, dynamic> _$GameSessionAnimalModelToJson(
  GameSessionAnimalModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'thumbnailUrl': instance.thumbnailUrl,
};

GameSessionMLModelModel _$GameSessionMLModelModelFromJson(
  Map<String, dynamic> json,
) => GameSessionMLModelModel(
  id: json['id'] as String,
  name: json['name'] as String,
  version: json['version'] as String,
);

Map<String, dynamic> _$GameSessionMLModelModelToJson(
  GameSessionMLModelModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'version': instance.version,
};

GameSessionModel _$GameSessionModelFromJson(
  Map<String, dynamic> json,
) => GameSessionModel(
  id: json['id'] as String,
  userId: json['userId'] as String,
  animalId: json['animalId'] as String,
  modelId: json['modelId'] as String,
  predictionLabel: json['predictionLabel'] as String,
  confidenceScore: (json['confidenceScore'] as num).toDouble(),
  gameScore: (json['gameScore'] as num).toInt(),
  focusScore: (json['focusScore'] as num?)?.toDouble(),
  drawingDuration: (json['drawingDuration'] as num).toInt(),
  startedAt: DateTime.parse(json['startedAt'] as String),
  finishedAt: DateTime.parse(json['finishedAt'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
  imageUrl: json['imageUrl'] as String?,
  animal: json['animal'] == null
      ? null
      : GameSessionAnimalModel.fromJson(json['animal'] as Map<String, dynamic>),
  model: json['model'] == null
      ? null
      : GameSessionMLModelModel.fromJson(json['model'] as Map<String, dynamic>),
);

Map<String, dynamic> _$GameSessionModelToJson(GameSessionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'animalId': instance.animalId,
      'modelId': instance.modelId,
      'predictionLabel': instance.predictionLabel,
      'confidenceScore': instance.confidenceScore,
      'gameScore': instance.gameScore,
      'focusScore': instance.focusScore,
      'drawingDuration': instance.drawingDuration,
      'startedAt': instance.startedAt.toIso8601String(),
      'finishedAt': instance.finishedAt.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'imageUrl': instance.imageUrl,
      'animal': instance.animal,
      'model': instance.model,
    };
