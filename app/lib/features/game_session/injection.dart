import 'package:get_it/get_it.dart';

import '../../core/network/api_client.dart';
import '../ml_model/domain/usecases/get_active_model_usecase.dart';

import 'data/datasources/game_session_remote_data_source.dart';
import 'data/repositories/game_session_repository_impl.dart';
import 'data/services/game_scoring_service.dart';
import 'domain/repositories/game_session_repository.dart';
import 'domain/usecases/submit_game_result_usecase.dart';
import 'domain/usecases/get_game_history_usecase.dart';
import 'domain/usecases/get_game_session_detail_usecase.dart';
import 'presentation/bloc/submit/submit_game_cubit.dart';
import 'presentation/bloc/history/history_cubit.dart';
import 'presentation/bloc/detail/session_detail_cubit.dart';

Future<void> initGameSessionFeature(GetIt di) async {
  // Services
  di.registerLazySingleton<GameScoringService>(() => GameScoringService());

  // Data sources
  di.registerLazySingleton<GameSessionRemoteDataSource>(
    () => GameSessionRemoteDataSourceImpl(di<ApiClient>()),
  );

  // Repositories
  di.registerLazySingleton<GameSessionRepository>(
    () => GameSessionRepositoryImpl(di<GameSessionRemoteDataSource>()),
  );

  // Use cases
  di.registerLazySingleton<SubmitGameResultUseCase>(
    () => SubmitGameResultUseCase(di<GameSessionRepository>()),
  );
  di.registerLazySingleton<GetGameHistoryUseCase>(
    () => GetGameHistoryUseCase(di<GameSessionRepository>()),
  );
  di.registerLazySingleton<GetGameSessionDetailUseCase>(
    () => GetGameSessionDetailUseCase(di<GameSessionRepository>()),
  );

  // Cubits
  di.registerFactory<SubmitGameCubit>(
    () => SubmitGameCubit(
      di<SubmitGameResultUseCase>(),
      di<GetActiveModelUseCase>(),
      di<GameScoringService>(),
    ),
  );
  di.registerFactory<HistoryCubit>(
    () => HistoryCubit(di<GetGameHistoryUseCase>()),
  );
  di.registerFactory<SessionDetailCubit>(
    () => SessionDetailCubit(di<GetGameSessionDetailUseCase>()),
  );
}
