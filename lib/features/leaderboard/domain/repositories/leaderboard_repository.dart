import '../entities/leaderboard_entry_entity.dart';
import '../entities/my_rank_entity.dart';
import '../entities/leaderboard_snapshot_entity.dart';

abstract class LeaderboardRepository {
  Future<List<LeaderboardEntryEntity>> getLiveLeaderboard({int limit = 100});
  Future<MyRankEntity> getMyRank();
  Future<LeaderboardSnapshotEntity> getLeaderboardSnapshot({
    required String period,
    required String periodLabel,
  });
}
