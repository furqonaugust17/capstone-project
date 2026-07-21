import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_dimensions.dart';
import 'package:app/core/theme/app_spacing.dart';
import 'package:app/core/theme/app_text_styles.dart';
import 'package:app/core/theme/app_typography.dart';
import 'package:go_router/go_router.dart';

import '../widgets/result_action_buttons.dart';
import '../widgets/result_image_card.dart';
import '../widgets/result_stat_card.dart';
import '../widgets/score_badge.dart';

class ResultSceneSection extends StatelessWidget {
  final Uint8List? imageBytes;
  final double? similarityPercent;
  final String? selectedAnimal;
  final int? duration;
  final int? gameScore;

  const ResultSceneSection({
    super.key,
    this.imageBytes,
    this.similarityPercent,
    this.selectedAnimal,
    this.duration,
    this.gameScore,
  });

  String _displayAnimalLabel() {
    return selectedAnimal ?? 'Kucing';
  }

  String _fallbackResultImage() {
    return 'assets/images/result/cat_drawing.png';
  }

  double _calculateRating(double similarity, int timeInSeconds) {
    // Similarity weight: Max 2.8 stars
    double baseScore = (similarity / 100.0) * 2.8;

    // Time bonus weight: Max 0.2 stars
    double timeBonus = 0.0;
    if (timeInSeconds <= 15) {
      timeBonus = 0.2;
    } else if (timeInSeconds <= 60) {
      // Scales down linearly from 0.2 to 0.0 between 15 and 60 seconds
      timeBonus = 0.2 - ((timeInSeconds - 15) / 45.0) * 0.2;
    }

    // Clamp total score to [0.0, 3.0]
    return (baseScore + timeBonus).clamp(0.0, 3.0);
  }

  String _formatDuration(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String _getMotivationalMessage(double similarity, String animalLabel) {
    if (similarity >= 80.0) {
      return 'Hebat! Ini adalah $animalLabel yang sempurna!';
    } else if (similarity >= 50.0) {
      return 'Bagus sekali! Ini terlihat seperti $animalLabel!';
    } else if (similarity >= 30.0) {
      return 'Usaha yang bagus! Ayo coba gambar $animalLabel lagi!';
    } else {
      return 'Wah, unik sekali! Tetap semangat menggambar $animalLabel ya!';
    }
  }

  @override
  Widget build(BuildContext context) {
    final similarityText = '${(similarityPercent ?? 0).toStringAsFixed(1)}%';
    final animalLabel = _displayAnimalLabel();
    final durationText = _formatDuration(duration ?? 0);
    const artboardWidth = 917.0;
    const artboardHeight = 412.0;
    const bodyTop = AppDimensions.appBarHeight + AppSpacing.sm;

    return RepaintBoundary(
      child: SizedBox(
        width: artboardWidth,
        height: artboardHeight,
        child: Stack(
          children: [
            Positioned.fill(child: Container(color: AppColors.background)),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              height: AppDimensions.appBarHeight,
              child: Container(
                color: AppColors.headerTint.withValues(alpha: 0.8),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                child: Row(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => context.go('/'),
                        borderRadius: BorderRadius.circular(999),
                        child: Container(
                          width: AppDimensions.avatarMedium,
                          height: AppDimensions.avatarMedium,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: AppColors.primary,
                            size: AppDimensions.iconMedium,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    ScoreBadge(score: gameScore != null ? gameScore.toString() : '...'),
                  ],
                ),
              ),
            ),
            Positioned(
              left: AppSpacing.xxl,
              right: AppSpacing.xxl,
              top: bodyTop,
              bottom: AppSpacing.xxl,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.xxl),
                      child: ResultImageCard(
                        imageAsset: _fallbackResultImage(),
                        imageBytes: imageBytes,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _getMotivationalMessage(
                            similarityPercent ?? 0.0,
                            animalLabel,
                          ),
                          textAlign: TextAlign.center,
                          style: AppTextStyles.displayMedium.copyWith(
                            fontSize: 30,
                            height: 40 / 36,
                            letterSpacing: -0.9,
                            color: AppColors.textNavy,
                            fontWeight: AppTypography.fwBold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        RatingBarIndicator(
                          rating: _calculateRating(
                            similarityPercent ?? 0.0,
                            duration ?? 0,
                          ),
                          itemBuilder: (context, index) =>
                              const Icon(Icons.star, color: AppColors.primary),
                          itemCount: 3,
                          itemSize: 40.0,
                          unratedColor: AppColors.primary.withValues(
                            alpha: 0.2,
                          ),
                          direction: Axis.horizontal,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            Expanded(
                              child: ResultStatCard(
                                title: 'KEMIRIPAN',
                                value: similarityText,
                                icon: const Icon(
                                  Icons.lightbulb,
                                  color: AppColors.primary,
                                  size: 18,
                                ),
                                iconBackground: AppColors.secondary,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: ResultStatCard(
                                title: 'WAKTU',
                                value: durationText,
                                icon: const Icon(
                                  Icons.timer,
                                  color: AppColors.success,
                                  size: 18,
                                ),
                                iconBackground: AppColors.successTint,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        const ResultActionButtons(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
