part of 'history_cubit.dart';

enum HistoryStatus { initial, loading, success, error }

class HistoryState extends Equatable {
  final HistoryStatus status;
  final List<GameSessionEntity> items;
  final bool hasReachedMax;
  final int page;
  final String? errorMessage;

  const HistoryState({
    this.status = HistoryStatus.initial,
    this.items = const <GameSessionEntity>[],
    this.hasReachedMax = false,
    this.page = 1,
    this.errorMessage,
  });

  HistoryState copyWith({
    HistoryStatus? status,
    List<GameSessionEntity>? items,
    bool? hasReachedMax,
    int? page,
    String? errorMessage,
  }) {
    return HistoryState(
      status: status ?? this.status,
      items: items ?? this.items,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, items, hasReachedMax, page, errorMessage];
}
