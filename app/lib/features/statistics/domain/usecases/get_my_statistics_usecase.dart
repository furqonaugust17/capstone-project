import '../entities/user_statistic_entity.dart';
import '../repositories/statistics_repository.dart';

class GetMyStatisticsUseCase {
  final StatisticsRepository _repository;

  GetMyStatisticsUseCase(this._repository);

  Future<UserStatisticEntity> call() {
    return _repository.getMyStatistics();
  }
}
