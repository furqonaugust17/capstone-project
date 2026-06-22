import 'package:app/core/network/models/paginated_response.dart';

import '../../domain/entities/game_session_entity.dart';
import '../../domain/repositories/game_session_repository.dart';
import '../datasources/game_session_remote_data_source.dart';
import '../models/submit_game_request.dart';

class GameSessionRepositoryImpl implements GameSessionRepository {
  final GameSessionRemoteDataSource _remoteDataSource;

  GameSessionRepositoryImpl(this._remoteDataSource);

  @override
  Future<GameSessionEntity> submitResult(SubmitGameRequest request) async {
    final model = await _remoteDataSource.submitGameResult(request);
    return model.toEntity();
  }

  @override
  Future<PaginatedResponse<GameSessionEntity>> getHistory({
    int page = 1,
    int limit = 10,
  }) async {
    final response = await _remoteDataSource.getHistory(
      page: page,
      limit: limit,
    );
    return PaginatedResponse<GameSessionEntity>(
      data: response.data.map((model) => model.toEntity()).toList(),
      meta: response.meta,
    );
  }

  @override
  Future<GameSessionEntity> getSessionDetail(String id) async {
    final model = await _remoteDataSource.getSessionDetail(id);
    return model.toEntity();
  }
}
