import 'package:app/core/ml/tflite_service.dart';
import 'get_active_model_usecase.dart';

class EnsureModelReadyUseCase {
  final GetActiveModelUseCase _getActiveModelUseCase;
  final TFLiteService _tfLiteService;

  const EnsureModelReadyUseCase(
    this._getActiveModelUseCase,
    this._tfLiteService,
  );

  Future<void> call() async {
    try {
      // Fetch from API, which downloads and caches the model
      final activeModel = await _getActiveModelUseCase();

      print('EnsureModelReadyUseCase: localPath=${activeModel.fileUrl}, labels=${activeModel.labels}');

      // Initialize TFLiteService using the cached file and API labels
      await _tfLiteService.initFromFile(
        activeModel.fileUrl, // Now contains local path from Cache Service
        labels: activeModel.labels,
      );

      print('EnsureModelReadyUseCase: Model loaded successfully!');
    } catch (e) {
      print('EnsureModelReadyUseCase: Online model failed ($e), falling back to bundled model...');
      // Fallback to bundled model if API/download fails
      try {
        await _tfLiteService.init();
        print('EnsureModelReadyUseCase: Bundled model loaded as fallback.');
      } catch (fallbackError) {
        print('EnsureModelReadyUseCase: Bundled model also failed: $fallbackError');
        throw TFLiteServiceException(
          'Failed to load any ML model.',
          cause: fallbackError,
        );
      }
    }
  }
}
