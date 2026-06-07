import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:app/core/theme/app_colors.dart';
import 'package:app/features/home/presentation/sections/home_scene_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: FittedBox(
          fit: BoxFit.contain,
          child: HomeSceneSection(
            onStartPressed: () => context.push('/choose'),
          ),
        ),
      ),
    );
  }
}
