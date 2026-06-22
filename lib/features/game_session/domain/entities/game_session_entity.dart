import 'package:equatable/equatable.dart';

class GameSessionEntity extends Equatable {
  final String id;
  final String predictionLabel;
  final double confidenceScore;
  final int gameScore;
  final double? focusScore;
  final int drawingDuration;
  final DateTime startedAt;
  final DateTime finishedAt;
  final String? animalName;
  final String? animalThumbnailUrl;
  final String? modelName;
  final String? modelVersion;
  final String? imageUrl;

  const GameSessionEntity({
    required this.id,
    required this.predictionLabel,
    required this.confidenceScore,
    required this.gameScore,
    this.focusScore,
    required this.drawingDuration,
    required this.startedAt,
    required this.finishedAt,
    this.animalName,
    this.animalThumbnailUrl,
    this.modelName,
    this.modelVersion,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
        id,
        predictionLabel,
        confidenceScore,
        gameScore,
        focusScore,
        drawingDuration,
        startedAt,
        finishedAt,
        animalName,
        animalThumbnailUrl,
        modelName,
        modelVersion,
        imageUrl,
      ];
}
