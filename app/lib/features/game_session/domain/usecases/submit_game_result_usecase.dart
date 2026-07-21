import '../../data/models/submit_game_request.dart';
import '../entities/game_session_entity.dart';
import '../repositories/game_session_repository.dart';

class SubmitGameResultUseCase {
  final GameSessionRepository _repository;

  const SubmitGameResultUseCase(this._repository);

  Future<GameSessionEntity> call(SubmitGameRequest request) async {
    return await _repository.submitResult(request);
  }
}
