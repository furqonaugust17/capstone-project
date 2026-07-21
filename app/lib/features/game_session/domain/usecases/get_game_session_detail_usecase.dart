import '../entities/game_session_entity.dart';
import '../repositories/game_session_repository.dart';

class GetGameSessionDetailUseCase {
  final GameSessionRepository _repository;

  const GetGameSessionDetailUseCase(this._repository);

  Future<GameSessionEntity> call(String id) async {
    return await _repository.getSessionDetail(id);
  }
}
