import '../entities/user_statistic_entity.dart';

abstract class StatisticsRepository {
  Future<UserStatisticEntity> getMyStatistics();
}
