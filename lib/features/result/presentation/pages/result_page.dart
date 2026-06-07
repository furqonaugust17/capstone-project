import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:app/core/theme/app_colors.dart';

import '../sections/result_scene_section.dart';

class ResultPage extends StatelessWidget {
  final Uint8List? imageBytes;
  final int? srcWidth;
  final int? srcHeight;
  final double? similarityPercent;
  final String? selectedAnimal;
  final int? duration;

  const ResultPage({
    super.key,
    this.imageBytes,
    this.srcWidth,
    this.srcHeight,
    this.similarityPercent,
    this.selectedAnimal,
    this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: FittedBox(
          fit: BoxFit.contain,
          child: ResultSceneSection(
            imageBytes: imageBytes,
            similarityPercent: similarityPercent,
            selectedAnimal: selectedAnimal,
            duration: duration,
          ),
        ),
      ),
    );
  }
}
