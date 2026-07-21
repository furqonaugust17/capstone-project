import 'package:equatable/equatable.dart';

class LeaderboardEntryEntity extends Equatable {
  final String userId;
  final int totalScore;
  final int totalGames;
  final String username;
  final String displayName;
  final String? avatarUrl;

  const LeaderboardEntryEntity({
    required this.userId,
    required this.totalScore,
    required this.totalGames,
    required this.username,
    required this.displayName,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [
        userId,
        totalScore,
        totalGames,
        username,
        displayName,
        avatarUrl,
      ];
}
