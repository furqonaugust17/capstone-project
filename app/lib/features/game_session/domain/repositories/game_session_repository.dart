import 'package:app/core/network/models/paginated_response.dart';
import '../../data/models/submit_game_request.dart';
import '../entities/game_session_entity.dart';

abstract class GameSessionRepository {
  Future<GameSessionEntity> submitResult(SubmitGameRequest request);
  Future<PaginatedResponse<GameSessionEntity>> getHistory({
    int page = 1,
    int limit = 10,
  });
  Future<GameSessionEntity> getSessionDetail(String id);
}
