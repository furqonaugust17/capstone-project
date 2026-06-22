import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/game_session_entity.dart';
import '../../../domain/usecases/submit_game_result_usecase.dart';
import '../../../data/models/submit_game_request.dart';
import '../../../data/services/game_scoring_service.dart';
import '../../../../ml_model/domain/usecases/get_active_model_usecase.dart';
import '../../../../animal/domain/entities/animal_entity.dart';

part 'submit_game_state.dart';

class SubmitGameCubit extends Cubit<SubmitGameState> {
  final SubmitGameResultUseCase _submitUseCase;
  final GetActiveModelUseCase _getActiveModelUseCase;
  final GameScoringService _scoringService;

  SubmitGameCubit(
    this._submitUseCase,
    this._getActiveModelUseCase,
    this._scoringService,
  ) : super(SubmitGameInitial());

  Future<void> submitResult({
    required AnimalEntity animal,
    required String predictionLabel,
    required double confidenceScore,
    required int drawingDuration,
    required DateTime startedAt,
    List<int>? imageBytes,
  }) async {
    emit(SubmitGameLoading());
    try {
      // 1. Get active model
      final activeModel = await _getActiveModelUseCase();

      // 2. Determine if prediction is correct
      final isCorrect = predictionLabel.toLowerCase() == animal.name.toLowerCase();

      // 3. Calculate score
      final gameScore = _scoringService.calculateScore(
        confidenceScore: confidenceScore,
        isCorrectPrediction: isCorrect,
        drawingDuration: drawingDuration,
        baseScore: animal.baseScore,
      );

      // 4. Submit to API
      final request = SubmitGameRequest(
        animalId: animal.id,
        modelId: activeModel.id,
        predictionLabel: predictionLabel,
        confidenceScore: confidenceScore,
        gameScore: gameScore,
        focusScore: 0.0,
        drawingDuration: drawingDuration,
        startedAt: startedAt.toUtc().toIso8601String(),
        fileBytes: imageBytes,
      );

      final session = await _submitUseCase(request);
      emit(SubmitGameSuccess(session: session));
    } catch (e) {
      emit(SubmitGameError(message: e.toString()));
    }
  }
}
