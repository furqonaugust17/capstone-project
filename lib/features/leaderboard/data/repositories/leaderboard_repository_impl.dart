import '../../domain/entities/leaderboard_entry_entity.dart';
import '../../domain/entities/my_rank_entity.dart';
import '../../domain/entities/leaderboard_snapshot_entity.dart';
import '../../domain/repositories/leaderboard_repository.dart';
import '../datasources/leaderboard_remote_data_source.dart';

class LeaderboardRepositoryImpl implements LeaderboardRepository {
  final LeaderboardRemoteDataSource _remoteDataSource;

  LeaderboardRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<LeaderboardEntryEntity>> getLiveLeaderboard({int limit = 100}) async {
    final models = await _remoteDataSource.getLiveLeaderboard(limit: limit);
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<MyRankEntity> getMyRank() async {
    final model = await _remoteDataSource.getMyRank();
    return model.toEntity();
  }

  @override
  Future<LeaderboardSnapshotEntity> getLeaderboardSnapshot({
    required String period,
    required String periodLabel,
  }) async {
    final model = await _remoteDataSource.getLeaderboardSnapshot(
      period: period,
      periodLabel: periodLabel,
    );
    return model.toEntity();
  }
}
