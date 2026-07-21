import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_my_statistics_usecase.dart';
import 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  final GetMyStatisticsUseCase _getMyStatisticsUseCase;

  StatisticsCubit(this._getMyStatisticsUseCase) : super(StatisticsInitial());

  Future<void> fetchMyStatistics() async {
    emit(StatisticsLoading());
    try {
      final statistics = await _getMyStatisticsUseCase();
      emit(StatisticsLoaded(statistics));
    } catch (e) {
      emit(StatisticsError(e.toString()));
    }
  }
}
