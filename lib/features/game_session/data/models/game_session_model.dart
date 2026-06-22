import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/game_session_entity.dart';

part 'game_session_model.g.dart';

@JsonSerializable()
class GameSessionAnimalModel {
  final String id;
  final String name;
  final String? thumbnailUrl;

  const GameSessionAnimalModel({
    required this.id,
    required this.name,
    this.thumbnailUrl,
  });

  factory GameSessionAnimalModel.fromJson(Map<String, dynamic> json) =>
      _$GameSessionAnimalModelFromJson(json);
}

@JsonSerializable()
class GameSessionMLModelModel {
  final String id;
  final String name;
  final String version;

  const GameSessionMLModelModel({
    required this.id,
    required this.name,
    required this.version,
  });

  factory GameSessionMLModelModel.fromJson(Map<String, dynamic> json) =>
      _$GameSessionMLModelModelFromJson(json);
}

@JsonSerializable()
class GameSessionModel {
  final String id;
  final String userId;
  final String animalId;
  final String modelId;
  final String predictionLabel;
  final double confidenceScore;
  final int gameScore;
  final double? focusScore;
  final int drawingDuration;
  final DateTime startedAt;
  final DateTime finishedAt;
  final DateTime createdAt;
  final String? imageUrl;
  final GameSessionAnimalModel? animal;
  final GameSessionMLModelModel? model;

  const GameSessionModel({
    required this.id,
    required this.userId,
    required this.animalId,
    required this.modelId,
    required this.predictionLabel,
    required this.confidenceScore,
    required this.gameScore,
    this.focusScore,
    required this.drawingDuration,
    required this.startedAt,
    required this.finishedAt,
    required this.createdAt,
    this.imageUrl,
    this.animal,
    this.model,
  });

  factory GameSessionModel.fromJson(Map<String, dynamic> json) =>
      _$GameSessionModelFromJson(json);

  Map<String, dynamic> toJson() => _$GameSessionModelToJson(this);

  GameSessionEntity toEntity() => GameSessionEntity(
        id: id,
        predictionLabel: predictionLabel,
        confidenceScore: confidenceScore,
        gameScore: gameScore,
        focusScore: focusScore,
        drawingDuration: drawingDuration,
        startedAt: startedAt,
        finishedAt: finishedAt,
        animalName: animal?.name,
        animalThumbnailUrl: animal?.thumbnailUrl,
        modelName: model?.name,
        modelVersion: model?.version,
        imageUrl: imageUrl,
      );
}
