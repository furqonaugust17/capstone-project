import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/leaderboard_entry_entity.dart';

part 'leaderboard_entry_model.g.dart';

@JsonSerializable()
class LeaderboardUserModel {
  final String username;
  final String displayName;
  final String? avatarUrl;

  const LeaderboardUserModel({
    required this.username,
    required this.displayName,
    this.avatarUrl,
  });

  factory LeaderboardUserModel.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$LeaderboardUserModelToJson(this);
}

@JsonSerializable()
class LeaderboardEntryModel {
  final String userId;
  final int totalScore;
  final int totalGames;
  final LeaderboardUserModel user;

  const LeaderboardEntryModel({
    required this.userId,
    required this.totalScore,
    required this.totalGames,
    required this.user,
  });

  factory LeaderboardEntryModel.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardEntryModelFromJson(json);

  Map<String, dynamic> toJson() => _$LeaderboardEntryModelToJson(this);

  LeaderboardEntryEntity toEntity() => LeaderboardEntryEntity(
        userId: userId,
        totalScore: totalScore,
        totalGames: totalGames,
        username: user.username,
        displayName: user.displayName,
        avatarUrl: user.avatarUrl,
      );
}
