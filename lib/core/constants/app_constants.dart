class AppConstants {
  static const dbName = 'app.sqlite';
  static const modelAssetPath = 'assets/models/sketch_model.tflite';
  static const labelsAssetPath = 'assets/models/labels.txt';

  static const defaultInputSize = 224;
  static const defaultInputChannels = 3;
  static const defaultOutputClasses = 5;

  static const defaultNormalizationMean = 127.5;
  static const defaultNormalizationStd = 127.5;
}
