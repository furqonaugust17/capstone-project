// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeaderboardUserModel _$LeaderboardUserModelFromJson(
  Map<String, dynamic> json,
) => LeaderboardUserModel(
  username: json['username'] as String,
  displayName: json['displayName'] as String,
  avatarUrl: json['avatarUrl'] as String?,
);

Map<String, dynamic> _$LeaderboardUserModelToJson(
  LeaderboardUserModel instance,
) => <String, dynamic>{
  'username': instance.username,
  'displayName': instance.displayName,
  'avatarUrl': instance.avatarUrl,
};

LeaderboardEntryModel _$LeaderboardEntryModelFromJson(
  Map<String, dynamic> json,
) => LeaderboardEntryModel(
  userId: json['userId'] as String,
  totalScore: (json['totalScore'] as num).toInt(),
  totalGames: (json['totalGames'] as num).toInt(),
  user: LeaderboardUserModel.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$LeaderboardEntryModelToJson(
  LeaderboardEntryModel instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'totalScore': instance.totalScore,
  'totalGames': instance.totalGames,
  'user': instance.user,
};
