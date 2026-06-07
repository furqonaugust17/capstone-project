import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'primary_button.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_colors.dart';

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Educational Animal Drawing')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Project foundation scaffolded — features go here',
              style: AppTextStyles.displayMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: 280,
              child: PrimaryButton(
                label: 'Start',
                onPressed: () => _onStartPressed(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _onStartPressed(BuildContext context) {
    context.push('/drawing');
  }
}
