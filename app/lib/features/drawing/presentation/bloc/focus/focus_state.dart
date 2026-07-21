part of 'focus_cubit.dart';

enum FocusLevel {
  high,     // Actively drawing (0 - 15s idle)
  medium,   // Short idle (15 - 30s) -> Gentle encouragement
  low,      // Long idle (30 - 45s) -> Adaptive hint assistance
  veryLow   // Very long idle (> 45s) -> Enhanced support
}

class FocusState {
  final FocusLevel level;
  final String? motivationalMessage;

  const FocusState({
    this.level = FocusLevel.high,
    this.motivationalMessage,
  });

  FocusState copyWith({
    FocusLevel? level,
    String? motivationalMessage,
    bool clearMessage = false,
  }) {
    return FocusState(
      level: level ?? this.level,
      motivationalMessage: clearMessage ? null : (motivationalMessage ?? this.motivationalMessage),
    );
  }
}
