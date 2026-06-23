import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/leaderboard_entry_entity.dart';

part 'leaderboard_entry_model.g.dart';

@JsonSerializable()
class LeaderboardEntryModel {
  final String userId;
  final int totalScore;
  final int totalGames;
  final String username;
  final String displayName;
  final String? avatarUrl;

  const LeaderboardEntryModel({
    required this.userId,
    required this.totalScore,
    required this.totalGames,
    required this.username,
    required this.displayName,
    this.avatarUrl,
  });

  factory LeaderboardEntryModel.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardEntryModelFromJson(json);

  Map<String, dynamic> toJson() => _$LeaderboardEntryModelToJson(this);

  LeaderboardEntryEntity toEntity() => LeaderboardEntryEntity(
        userId: userId,
        totalScore: totalScore,
        totalGames: totalGames,
        username: username,
        displayName: displayName,
        avatarUrl: avatarUrl,
      );
}
