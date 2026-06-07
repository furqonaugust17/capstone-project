import 'package:flutter/material.dart';

import 'package:app/core/theme/app_colors.dart';
import 'package:app/features/choose/presentation/sections/choose_scene_section.dart';

class ChooseAnimalPage extends StatelessWidget {
  const ChooseAnimalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: FittedBox(
          fit: BoxFit.contain,
          child: const ChooseSceneSection(),
        ),
      ),
    );
  }
}
