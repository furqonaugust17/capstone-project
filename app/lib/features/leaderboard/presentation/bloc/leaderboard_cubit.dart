import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_live_leaderboard_usecase.dart';
import '../../domain/usecases/get_my_rank_usecase.dart';
import '../../domain/usecases/get_leaderboard_snapshot_usecase.dart';
import 'leaderboard_state.dart';

class LeaderboardCubit extends Cubit<LeaderboardState> {
  final GetLiveLeaderboardUseCase _getLiveLeaderboardUseCase;
  final GetMyRankUseCase _getMyRankUseCase;
  final GetLeaderboardSnapshotUseCase _getLeaderboardSnapshotUseCase;

  LeaderboardCubit(
    this._getLiveLeaderboardUseCase,
    this._getMyRankUseCase,
    this._getLeaderboardSnapshotUseCase,
  ) : super(LeaderboardInitial());

  Future<void> fetchLiveLeaderboard({int limit = 100}) async {
    emit(LeaderboardLoading());
    try {
      final rankings = await _getLiveLeaderboardUseCase(limit: limit);
      final myRank = await _getMyRankUseCase().catchError((_) => null); // Optional failure for myRank
      
      emit(LeaderboardLoaded(liveRankings: rankings, myRank: myRank));
    } catch (e) {
      emit(LeaderboardError(e.toString()));
    }
  }

  Future<void> fetchSnapshot({required String period, required String periodLabel}) async {
    emit(LeaderboardLoading());
    try {
      final snapshot = await _getLeaderboardSnapshotUseCase(period: period, periodLabel: periodLabel);
      final myRank = await _getMyRankUseCase().catchError((_) => null);
      
      emit(LeaderboardLoaded(snapshot: snapshot, myRank: myRank));
    } catch (e) {
      emit(LeaderboardError(e.toString()));
    }
  }

  Future<void> fetchMyRank() async {
    if (state is LeaderboardLoaded) {
      try {
        final myRank = await _getMyRankUseCase();
        emit((state as LeaderboardLoaded).copyWith(myRank: myRank));
      } catch (e) {
        // Silently fail or handle specifically if just updating rank
      }
    }
  }
}
