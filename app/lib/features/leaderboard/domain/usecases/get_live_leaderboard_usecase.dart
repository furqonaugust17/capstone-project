import '../entities/leaderboard_entry_entity.dart';
import '../repositories/leaderboard_repository.dart';

class GetLiveLeaderboardUseCase {
  final LeaderboardRepository _repository;

  GetLiveLeaderboardUseCase(this._repository);

  Future<List<LeaderboardEntryEntity>> call({int limit = 100}) {
    return _repository.getLiveLeaderboard(limit: limit);
  }
}
