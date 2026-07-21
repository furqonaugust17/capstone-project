import 'package:equatable/equatable.dart';
import '../../domain/entities/leaderboard_entry_entity.dart';
import '../../domain/entities/my_rank_entity.dart';
import '../../domain/entities/leaderboard_snapshot_entity.dart';

sealed class LeaderboardState extends Equatable {
  const LeaderboardState();

  @override
  List<Object?> get props => [];
}

class LeaderboardInitial extends LeaderboardState {}

class LeaderboardLoading extends LeaderboardState {}

class LeaderboardLoaded extends LeaderboardState {
  final List<LeaderboardEntryEntity>? liveRankings;
  final LeaderboardSnapshotEntity? snapshot;
  final MyRankEntity? myRank;

  const LeaderboardLoaded({
    this.liveRankings,
    this.snapshot,
    this.myRank,
  });

  LeaderboardLoaded copyWith({
    List<LeaderboardEntryEntity>? liveRankings,
    LeaderboardSnapshotEntity? snapshot,
    MyRankEntity? myRank,
  }) {
    return LeaderboardLoaded(
      liveRankings: liveRankings ?? this.liveRankings,
      snapshot: snapshot ?? this.snapshot,
      myRank: myRank ?? this.myRank,
    );
  }

  @override
  List<Object?> get props => [liveRankings, snapshot, myRank];
}

class LeaderboardError extends LeaderboardState {
  final String message;

  const LeaderboardError(this.message);

  @override
  List<Object?> get props => [message];
}
