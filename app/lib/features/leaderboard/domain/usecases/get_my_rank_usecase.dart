import '../entities/my_rank_entity.dart';
import '../repositories/leaderboard_repository.dart';

class GetMyRankUseCase {
  final LeaderboardRepository _repository;

  GetMyRankUseCase(this._repository);

  Future<MyRankEntity> call() {
    return _repository.getMyRank();
  }
}
