import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'focus_state.dart';

class FocusCubit extends Cubit<FocusState> {
  Timer? _timer;
  int _secondsIdle = 0;

  // Custom timer periods (in seconds)
  static const int mediumFocusThreshold = 15;
  static const int lowFocusThreshold = 30;
  static const int veryLowFocusThreshold = 45;

  final List<String> _encouragingMessages = [
    '🌟 Hebat! Ayo lanjutkan gambarmu!',
    '🦁 Gambar hewanmu sudah mulai kelihatan bagus!',
    '✨ Kamu pintar sekali, ayo selesaikan!',
    '🎨 Asyik sekali menggambar, teruskan ya!',
  ];

  final List<String> _helpMessages = [
    '🐰 Butuh bantuan? Coba lihat gambar contohnya lagi.',
    '💡 Kamu bisa menggunakan petunjuk untuk melanjutkan gambar.',
    '🦊 Ayo selesaikan gambarnya bersama-sama!',
  ];

  FocusCubit() : super(const FocusState()) {
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _secondsIdle++;
      _analyzeFocus();
    });
  }

  void resetFocusTimer() {
    if (_secondsIdle > 0) {
      _secondsIdle = 0;
      if (state.level != FocusLevel.high) {
        emit(state.copyWith(
          level: FocusLevel.high,
          clearMessage: true,
        ));
      }
    }
  }

  void _analyzeFocus() {
    if (_secondsIdle >= veryLowFocusThreshold) {
      if (state.level != FocusLevel.veryLow) {
        // Pick helper message
        final msg = _helpMessages[_secondsIdle % _helpMessages.length];
        emit(state.copyWith(
          level: FocusLevel.veryLow,
          motivationalMessage: msg,
        ));
      }
    } else if (_secondsIdle >= lowFocusThreshold) {
      if (state.level != FocusLevel.low) {
        final msg = _helpMessages[_secondsIdle % _helpMessages.length];
        emit(state.copyWith(
          level: FocusLevel.low,
          motivationalMessage: msg,
        ));
      }
    } else if (_secondsIdle >= mediumFocusThreshold) {
      if (state.level != FocusLevel.medium) {
        final msg = _encouragingMessages[_secondsIdle % _encouragingMessages.length];
        emit(state.copyWith(
          level: FocusLevel.medium,
          motivationalMessage: msg,
        ));
      }
    } else {
      if (state.level != FocusLevel.high) {
        emit(state.copyWith(
          level: FocusLevel.high,
          clearMessage: true,
        ));
      }
    }
  }

  void clearMessage() {
    if (state.motivationalMessage != null) {
      emit(state.copyWith(clearMessage: true));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
