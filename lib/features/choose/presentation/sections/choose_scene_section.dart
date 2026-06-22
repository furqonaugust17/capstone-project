import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/theme/app_spacing.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_text_styles.dart';
import 'package:app/features/animal/presentation/bloc/animal_bloc.dart';
import 'package:app/features/animal/presentation/bloc/animal_event.dart';
import 'package:app/features/animal/presentation/bloc/animal_state.dart';
import 'package:app/features/choose/presentation/widgets/animal_pill.dart';

class ChooseSceneSection extends StatelessWidget {
  const ChooseSceneSection({super.key});

  @override
  Widget build(BuildContext context) {
    const artboardWidth = 917.0;
    const artboardHeight = 412.0;

    return RepaintBoundary(
      child: SizedBox(
        width: artboardWidth,
        height: artboardHeight,
        child: Stack(
          children: [
            Positioned.fill(child: Container(color: Colors.white)),
            // Header back + title
            Positioned(
              left: 16,
              top: 12,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.primary,
                ),
                onPressed: () => Navigator.maybePop(context),
              ),
            ),
            // Right top label
            Positioned(
              right: 24,
              top: 20,
              child: Text(
                'HEWAN',
                style: AppTextStyles.button.copyWith(color: AppColors.primary),
              ),
            ),

            // Center title
            Positioned(
              top: 36,
              left: 0,
              right: 0,
              child: Text(
                'MAU MENGGAMBAR APA HARI INI?',
                textAlign: TextAlign.center,
                style: AppTextStyles.displayMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 28,
                ),
              ),
            ),

            // Choices row
            Positioned(
              left: AppSpacing.xxl,
              right: AppSpacing.xxl,
              top: 120,
              bottom: 20,
              child: BlocBuilder<AnimalBloc, AnimalState>(
                builder: (context, state) {
                  if (state is AnimalLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is AnimalError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.message,
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.error,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<AnimalBloc>().add(
                                const LoadAnimals(),
                              );
                            },
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    );
                  } else if (state is AnimalLoaded) {
                    if (state.animals.isEmpty) {
                      return Center(
                        child: Text(
                          'Belum ada hewan yang tersedia.',
                          style: AppTextStyles.bodyLarge,
                        ),
                      );
                    }
                    return Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: state.animals.map((animal) {
                            // Simple icon mapping fallback (or use cached network image later)
                            IconData animalIcon = Icons.pets;
                            if (animal.name.toLowerCase() == 'sapi')
                              animalIcon = Icons.grass;
                            if (animal.name.toLowerCase() == 'bebek')
                              animalIcon = Icons.water;
                            if (animal.name.toLowerCase() == 'ikan')
                              animalIcon = Icons.set_meal;
                            if (animal.name.toLowerCase().contains('lumba'))
                              animalIcon = Icons.pool;

                            return Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: AnimalPill(
                                label: animal.name,
                                icon: animalIcon,
                                onTap: () => context.push(
                                  '/mode',
                                  extra: {'animal': animal},
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
