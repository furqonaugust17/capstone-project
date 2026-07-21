import 'package:equatable/equatable.dart';
import 'leaderboard_entry_entity.dart';

class LeaderboardSnapshotEntity extends Equatable {
  final String period;
  final String periodLabel;
  final List<LeaderboardEntryEntity> rankings;

  const LeaderboardSnapshotEntity({
    required this.period,
    required this.periodLabel,
    required this.rankings,
  });

  @override
  List<Object?> get props => [period, periodLabel, rankings];
}
