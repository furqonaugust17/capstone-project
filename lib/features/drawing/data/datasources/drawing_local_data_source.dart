import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/stroke_model.dart';

/// Simple local data source using SharedPreferences for quick persistence.
/// In production replace with Drift implementation (DB) per project rules.
abstract class DrawingLocalDataSource {
  Future<void> save(String key, List<StrokeModel> strokes);
  Future<List<StrokeModel>> load(String key);
  Future<void> clear(String key);
}

class DrawingLocalDataSourceImpl implements DrawingLocalDataSource {
  final SharedPreferences prefs;
  DrawingLocalDataSourceImpl(this.prefs);

  @override
  Future<void> save(String key, List<StrokeModel> strokes) async {
    final jsonStr = jsonEncode(strokes.map((s) => s.toJson()).toList());
    await prefs.setString(key, jsonStr);
  }

  @override
  Future<List<StrokeModel>> load(String key) async {
    final jsonStr = prefs.getString(key);
    if (jsonStr == null) return [];
    final list = jsonDecode(jsonStr) as List;
    return list
        .map((e) => StrokeModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> clear(String key) async {
    await prefs.remove(key);
  }
}
