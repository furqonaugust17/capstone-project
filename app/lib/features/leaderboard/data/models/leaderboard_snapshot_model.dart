import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/leaderboard_snapshot_entity.dart';
import 'leaderboard_entry_model.dart';

part 'leaderboard_snapshot_model.g.dart';

@JsonSerializable()
class LeaderboardSnapshotModel {
  final String period;
  final String periodLabel;
  final List<LeaderboardEntryModel> rankings;

  const LeaderboardSnapshotModel({
    required this.period,
    required this.periodLabel,
    required this.rankings,
  });

  factory LeaderboardSnapshotModel.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardSnapshotModelFromJson(json);

  Map<String, dynamic> toJson() => _$LeaderboardSnapshotModelToJson(this);

  LeaderboardSnapshotEntity toEntity() => LeaderboardSnapshotEntity(
        period: period,
        periodLabel: periodLabel,
        rankings: rankings.map((e) => e.toEntity()).toList(),
      );
}
