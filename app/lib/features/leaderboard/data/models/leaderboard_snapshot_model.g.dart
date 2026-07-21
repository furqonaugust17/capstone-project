// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_snapshot_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeaderboardSnapshotModel _$LeaderboardSnapshotModelFromJson(
  Map<String, dynamic> json,
) => LeaderboardSnapshotModel(
  period: json['period'] as String,
  periodLabel: json['periodLabel'] as String,
  rankings: (json['rankings'] as List<dynamic>)
      .map((e) => LeaderboardEntryModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$LeaderboardSnapshotModelToJson(
  LeaderboardSnapshotModel instance,
) => <String, dynamic>{
  'period': instance.period,
  'periodLabel': instance.periodLabel,
  'rankings': instance.rankings,
};
