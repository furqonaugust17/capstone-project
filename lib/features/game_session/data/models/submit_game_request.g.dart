// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submit_game_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubmitGameRequest _$SubmitGameRequestFromJson(Map<String, dynamic> json) =>
    SubmitGameRequest(
      animalId: json['animalId'] as String,
      modelId: json['modelId'] as String,
      predictionLabel: json['predictionLabel'] as String,
      confidenceScore: (json['confidenceScore'] as num).toDouble(),
      gameScore: (json['gameScore'] as num).toInt(),
      focusScore: (json['focusScore'] as num?)?.toDouble(),
      drawingDuration: (json['drawingDuration'] as num).toInt(),
      startedAt: json['startedAt'] as String,
    );

Map<String, dynamic> _$SubmitGameRequestToJson(SubmitGameRequest instance) =>
    <String, dynamic>{
      'animalId': instance.animalId,
      'modelId': instance.modelId,
      'predictionLabel': instance.predictionLabel,
      'confidenceScore': instance.confidenceScore,
      'gameScore': instance.gameScore,
      'focusScore': instance.focusScore,
      'drawingDuration': instance.drawingDuration,
      'startedAt': instance.startedAt,
    };
