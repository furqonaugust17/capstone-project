import 'dart:math';

class GameScoringService {
  /// Menghitung skor game berdasarkan hasil inferensi dan gameplay.
  /// 
  /// Aturan:
  /// - Jika prediksi benar → skor = baseScore × confidenceMultiplier × speedBonus
  /// - Jika prediksi salah → skor = baseScore × 0.1 (penalti)
  /// - `confidenceMultiplier` = confidenceScore (0.0 - 1.0)
  /// - `speedBonus` = 1.0 + max(0, (120 - drawingDuration)) / 120 × 0.5
  /// - Skor minimal adalah 0
  int calculateScore({
    required double confidenceScore,
    required bool isCorrectPrediction,
    required int drawingDuration,
    required int baseScore,
  }) {
    if (baseScore <= 0) return 0;
    
    // Pastikan confidenceScore berada di rentang 0.0 - 1.0
    final validConfidence = confidenceScore.clamp(0.0, 1.0);

    if (!isCorrectPrediction) {
      // Penalti jika salah tebak: 10% dari base score
      return (baseScore * 0.1).round();
    }

    // Hitung speed bonus
    // Maksimal durasi untuk bonus adalah 120 detik.
    // Jika menggambar lebih cepat dari 120 detik, dapat bonus hingga +0.5 (1.5x)
    final timeLeft = max(0, 120 - drawingDuration);
    final speedBonus = 1.0 + (timeLeft / 120.0) * 0.5;

    // Hitung final skor
    final finalScore = (baseScore * validConfidence * speedBonus).round();

    return max(0, finalScore);
  }
}
