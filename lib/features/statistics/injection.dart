import 'package:get_it/get_it.dart';
import 'package:app/core/network/api_client.dart';

import 'data/datasources/statistics_remote_data_source.dart';
import 'data/repositories/statistics_repository_impl.dart';
import 'domain/repositories/statistics_repository.dart';
import 'domain/usecases/get_my_statistics_usecase.dart';
import 'presentation/bloc/statistics_cubit.dart';

Future<void> initStatisticsFeature(GetIt di) async {
  // Data sources
  di.registerLazySingleton<StatisticsRemoteDataSource>(
    () => StatisticsRemoteDataSourceImpl(di<ApiClient>()),
  );

  // Repositories
  di.registerLazySingleton<StatisticsRepository>(
    () => StatisticsRepositoryImpl(di<StatisticsRemoteDataSource>()),
  );

  // Use cases
  di.registerLazySingleton(
    () => GetMyStatisticsUseCase(di<StatisticsRepository>()),
  );

  // Blocs/Cubits
  di.registerFactory(
    () => StatisticsCubit(di<GetMyStatisticsUseCase>()),
  );
}
