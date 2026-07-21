import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/game_session_entity.dart';
import '../../../domain/usecases/get_game_session_detail_usecase.dart';

part 'session_detail_state.dart';

class SessionDetailCubit extends Cubit<SessionDetailState> {
  final GetGameSessionDetailUseCase _getDetailUseCase;

  SessionDetailCubit(this._getDetailUseCase) : super(SessionDetailInitial());

  Future<void> fetchDetail(String id) async {
    emit(SessionDetailLoading());
    try {
      final session = await _getDetailUseCase(id);
      emit(SessionDetailSuccess(session: session));
    } catch (e) {
      emit(SessionDetailError(message: e.toString()));
    }
  }
}
