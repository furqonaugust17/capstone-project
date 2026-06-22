import 'package:json_annotation/json_annotation.dart';

part 'submit_game_request.g.dart';

@JsonSerializable()
class SubmitGameRequest {
  final String animalId;
  final String modelId;
  final String predictionLabel;
  final double confidenceScore;
  final int gameScore;
  final double? focusScore;
  final int drawingDuration;
  final String startedAt; // ISO 8601

  @JsonKey(ignore: true)
  final List<int>? fileBytes;

  const SubmitGameRequest({
    required this.animalId,
    required this.modelId,
    required this.predictionLabel,
    required this.confidenceScore,
    required this.gameScore,
    this.focusScore,
    required this.drawingDuration,
    required this.startedAt,
    this.fileBytes,
  });

  Map<String, dynamic> toJson() => _$SubmitGameRequestToJson(this);
}
