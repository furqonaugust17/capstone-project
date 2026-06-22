import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/game_session_entity.dart';
import '../../../domain/usecases/get_game_history_usecase.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final GetGameHistoryUseCase _getHistoryUseCase;

  HistoryCubit(this._getHistoryUseCase) : super(const HistoryState());

  Future<void> fetchHistory({bool refresh = false}) async {
    if (state.hasReachedMax && !refresh) return;

    if (refresh) {
      emit(
        state.copyWith(
          status: HistoryStatus.loading,
          items: [],
          page: 1,
          hasReachedMax: false,
        ),
      );
    } else if (state.status == HistoryStatus.initial) {
      emit(state.copyWith(status: HistoryStatus.loading));
    }

    try {
      final response = await _getHistoryUseCase(page: state.page, limit: 10);

      if (response.data.isEmpty) {
        emit(
          state.copyWith(status: HistoryStatus.success, hasReachedMax: true),
        );
      } else {
        emit(
          state.copyWith(
            status: HistoryStatus.success,
            items: List.of(state.items)..addAll(response.data),
            page: state.page + 1,
            hasReachedMax:
                response.meta.page >= response.meta.totalPages,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(status: HistoryStatus.error, errorMessage: e.toString()),
      );
    }
  }
}
