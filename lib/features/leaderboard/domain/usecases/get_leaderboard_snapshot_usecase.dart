import '../entities/leaderboard_snapshot_entity.dart';
import '../repositories/leaderboard_repository.dart';

class GetLeaderboardSnapshotUseCase {
  final LeaderboardRepository _repository;

  GetLeaderboardSnapshotUseCase(this._repository);

  Future<LeaderboardSnapshotEntity> call({
    required String period,
    required String periodLabel,
  }) {
    return _repository.getLeaderboardSnapshot(
      period: period,
      periodLabel: periodLabel,
    );
  }
}
