import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MLModelCacheService {
  final Dio _dio;
  final SharedPreferences _prefs;
  
  static const String _cachedModelVersionKey = 'cached_ml_model_version';
  static const String _cachedModelPathKey = 'cached_ml_model_path';

  /// TFLite files start with these magic bytes: "TFL3" (0x54464C33)
  static const List<int> _tfliteMagic = [0x54, 0x46, 0x4C, 0x33];
  /// Or the older FlatBuffer magic bytes
  static const int _minValidFileSize = 1024; // 1KB minimum

  const MLModelCacheService(this._dio, this._prefs);

  /// Downloads and caches the TFLite model. Returns the local file path.
  /// If the version matches the cached version, returns the cached file path.
  Future<String> downloadAndCacheModel({
    required String fileUrl,
    required String version,
  }) async {
    final cachedVersion = _prefs.getString(_cachedModelVersionKey);
    final cachedPath = _prefs.getString(_cachedModelPathKey);

    // If version is the same and file exists AND is valid, return the cached path
    if (cachedVersion == version && cachedPath != null) {
      final file = File(cachedPath);
      if (await file.exists()) {
        final size = await file.length();
        if (size > _minValidFileSize) {
          print('MLModelCacheService: Using cached model v$version ($size bytes)');
          return cachedPath;
        }
        // File exists but is too small — redownload
        print('MLModelCacheService: Cached file too small ($size bytes), redownloading...');
      }
    }

    // Otherwise, download the new model
    final directory = await getApplicationDocumentsDirectory();
    final fileName = 'ml_model_v$version.tflite';
    final savePath = '${directory.path}/$fileName';

    try {
      print('MLModelCacheService: Downloading model from $fileUrl');
      
      await _dio.download(
        fileUrl,
        savePath,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
          receiveTimeout: const Duration(seconds: 120),
        ),
      );

      // Validate the downloaded file
      final file = File(savePath);
      final size = await file.length();
      
      if (size < _minValidFileSize) {
        await file.delete();
        throw Exception(
          'Downloaded file is too small ($size bytes). '
          'The URL may be returning an error page instead of a model file.',
        );
      }

      // Check first few bytes for TFLite signature
      final header = await file.openRead(0, 4).first;
      final isTfLite = header.length >= 4 &&
          (header[0] == _tfliteMagic[0] && header[1] == _tfliteMagic[1] &&
           header[2] == _tfliteMagic[2] && header[3] == _tfliteMagic[3]);
      
      print('MLModelCacheService: Downloaded $size bytes, TFLite magic: $isTfLite');

      // Save to cache
      await _prefs.setString(_cachedModelVersionKey, version);
      await _prefs.setString(_cachedModelPathKey, savePath);

      return savePath;
    } catch (e) {
      // Clean up partial download
      try {
        final file = File(savePath);
        if (await file.exists()) await file.delete();
      } catch (_) {}
      throw Exception('Failed to download ML model: $e');
    }
  }

  /// Returns the currently cached model path if it exists
  String? getCachedModelPath() {
    return _prefs.getString(_cachedModelPathKey);
  }

  /// Clears the cached model data
  Future<void> clearCache() async {
    final cachedPath = _prefs.getString(_cachedModelPathKey);
    if (cachedPath != null) {
      try {
        final file = File(cachedPath);
        if (await file.exists()) await file.delete();
      } catch (_) {}
    }
    await _prefs.remove(_cachedModelVersionKey);
    await _prefs.remove(_cachedModelPathKey);
  }
}
