import '../../domain/entities/user_statistic_entity.dart';
import '../../domain/repositories/statistics_repository.dart';
import '../datasources/statistics_remote_data_source.dart';

class StatisticsRepositoryImpl implements StatisticsRepository {
  final StatisticsRemoteDataSource _remoteDataSource;

  StatisticsRepositoryImpl(this._remoteDataSource);

  @override
  Future<UserStatisticEntity> getMyStatistics() async {
    final model = await _remoteDataSource.getMyStatistics();
    return model.toEntity();
  }
}
