import 'package:get_it/get_it.dart';
import 'data/datasources/leaderboard_remote_data_source.dart';
import 'domain/repositories/leaderboard_repository.dart';
import 'data/repositories/leaderboard_repository_impl.dart';
import 'domain/usecases/get_live_leaderboard_usecase.dart';
import 'domain/usecases/get_my_rank_usecase.dart';
import 'domain/usecases/get_leaderboard_snapshot_usecase.dart';
import 'presentation/bloc/leaderboard_cubit.dart';

Future<void> initLeaderboardFeature(GetIt di) async {
  // Data sources
  di.registerLazySingleton<LeaderboardRemoteDataSource>(
    () => LeaderboardRemoteDataSourceImpl(di()),
  );

  // Repositories
  di.registerLazySingleton<LeaderboardRepository>(
    () => LeaderboardRepositoryImpl(di()),
  );

  // Use cases
  di.registerLazySingleton(() => GetLiveLeaderboardUseCase(di()));
  di.registerLazySingleton(() => GetMyRankUseCase(di()));
  di.registerLazySingleton(() => GetLeaderboardSnapshotUseCase(di()));

  // Cubits / Blocs
  di.registerFactory(
    () => LeaderboardCubit(di(), di(), di()),
  );
}
