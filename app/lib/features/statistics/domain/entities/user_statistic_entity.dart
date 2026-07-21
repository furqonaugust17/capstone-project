import 'package:equatable/equatable.dart';

class UserStatisticEntity extends Equatable {
  final String userId;
  final int totalGames;
  final int totalScore;
  final int highestScore;
  final double averageFocus;
  final int totalDrawingTime;
  final DateTime updatedAt;

  const UserStatisticEntity({
    required this.userId,
    required this.totalGames,
    required this.totalScore,
    required this.highestScore,
    required this.averageFocus,
    required this.totalDrawingTime,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        userId,
        totalGames,
        totalScore,
        highestScore,
        averageFocus,
        totalDrawingTime,
        updatedAt,
      ];
}
