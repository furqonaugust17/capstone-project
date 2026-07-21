import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:app/core/theme/app_colors.dart';
import 'package:app/features/home/presentation/sections/home_scene_section.dart';
import 'package:app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:app/features/auth/presentation/bloc/auth_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final user = authState is Authenticated ? authState.user : null;
        final themeUrl = user?.equippedThemeUrl;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              if (themeUrl != null)
                Positioned.fill(
                  child: Image.network(
                    themeUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                  ),
                ),
              Center(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: HomeSceneSection(
                    onStartPressed: () => context.push('/choose'),
                    showDecorations: themeUrl == null, // Pass flag to hide original decorations
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

