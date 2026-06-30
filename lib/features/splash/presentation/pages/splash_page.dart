import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../injection/injection.dart';
import '../bloc/splash_cubit.dart';
import '../bloc/splash_state.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di<SplashCubit>()..initializeApp(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocConsumer<SplashCubit, SplashState>(
          listener: (context, state) {
            if (state is SplashUnauthenticated) {
              context.go('/login');
            } else if (state is SplashReady) {
              context.go('/');
            }
          },
          builder: (context, state) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo Image
                  Image.asset(
                    'assets/images/icon.png',
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(height: 24),
                  if (state is SplashLoading) ...[
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      state.statusMessage,
                      style: AppTextStyles.bodyLarge,
                    ),
                  ] else if (state is SplashError) ...[
                    Text(
                      state.message,
                      style: AppTextStyles.bodyLarge.copyWith(color: AppColors.error),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<SplashCubit>().initializeApp();
                      },
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
