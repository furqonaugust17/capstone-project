import 'package:app/core/network/models/paginated_response.dart';

import '../entities/game_session_entity.dart';
import '../repositories/game_session_repository.dart';

class GetGameHistoryUseCase {
  final GameSessionRepository _repository;

  const GetGameHistoryUseCase(this._repository);

  Future<PaginatedResponse<GameSessionEntity>> call({
    int page = 1,
    int limit = 10,
  }) async {
    return await _repository.getHistory(page: page, limit: limit);
  }
}
