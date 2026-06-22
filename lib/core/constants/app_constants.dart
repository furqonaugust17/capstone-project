class AppConstants {
  static const dbName = 'app.sqlite';
  static const modelAssetPath = 'assets/models/sketch_model.tflite';
  static const labelsAssetPath = 'assets/models/labels.txt';

  static const defaultInputSize = 224;
  static const defaultInputChannels = 3;
  static const defaultOutputClasses = 5;

  static const defaultNormalizationMean = 127.5;
  static const defaultNormalizationStd = 127.5;

  // API Endpoints
  static const authLoginPath = '/auth/login';
  static const authRegisterPath = '/auth/register';
  static const authRefreshPath = '/auth/refresh';
  static const authMePath = '/auth/me';
  static const authLogoutPath = '/auth/logout';
  static const animalsPath = '/animals';
  static const mlModelsActivePath = '/ml-models/active';
  static const gameSessionsPath = '/game-sessions';

  // Timeouts
  static const connectTimeout = Duration(seconds: 15);
  static const receiveTimeout = Duration(seconds: 15);
  static const sendTimeout = Duration(seconds: 15);

  // Storage Keys
  static const accessTokenKey = 'access_token';
  static const refreshTokenKey = 'refresh_token';
  static const cachedModelVersionKey = 'cached_model_version';
  static const cachedModelPathKey = 'cached_model_path';
}
