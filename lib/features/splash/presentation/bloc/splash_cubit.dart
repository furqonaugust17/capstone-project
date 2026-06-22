import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/domain/usecases/check_auth_status_usecase.dart';
import '../../../ml_model/domain/usecases/ensure_model_ready_usecase.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;
  final EnsureModelReadyUseCase _ensureModelReadyUseCase;

  SplashCubit({
    required CheckAuthStatusUseCase checkAuthStatusUseCase,
    required EnsureModelReadyUseCase ensureModelReadyUseCase,
  }) : _checkAuthStatusUseCase = checkAuthStatusUseCase,
       _ensureModelReadyUseCase = ensureModelReadyUseCase,
       super(SplashInitial());

  Future<void> initializeApp() async {
    try {
      emit(const SplashLoading("Memeriksa sesi..."));

      // 1. Check Auth Status
      final user = await _checkAuthStatusUseCase();
      if (user == null) {
        emit(SplashUnauthenticated());
        return;
      }

      emit(const SplashLoading("Mempersiapkan AI Model..."));

      // 2. Download/Cache Active Model & Init TFLiteService
      await _ensureModelReadyUseCase();

      emit(SplashReady());
    } catch (e) {
      emit(
        SplashError(e.toString().replaceFirst(RegExp(r'^.*?Exception: '), '')),
      );
    }
  }
}
