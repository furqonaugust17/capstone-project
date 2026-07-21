import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user_statistic_entity.dart';

part 'user_statistic_model.g.dart';

@JsonSerializable()
class UserStatisticModel {
  final String userId;
  final int totalGames;
  final int totalScore;
  final int highestScore;
  final double averageFocus;
  final int totalDrawingTime;
  final DateTime updatedAt;

  const UserStatisticModel({
    required this.userId,
    required this.totalGames,
    required this.totalScore,
    required this.highestScore,
    required this.averageFocus,
    required this.totalDrawingTime,
    required this.updatedAt,
  });

  factory UserStatisticModel.fromJson(Map<String, dynamic> json) =>
      _$UserStatisticModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserStatisticModelToJson(this);

  UserStatisticEntity toEntity() => UserStatisticEntity(
        userId: userId,
        totalGames: totalGames,
        totalScore: totalScore,
        highestScore: highestScore,
        averageFocus: averageFocus,
        totalDrawingTime: totalDrawingTime,
        updatedAt: updatedAt,
      );
}
