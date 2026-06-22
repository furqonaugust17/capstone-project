import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/injection/injection.dart';
import 'package:app/features/animal/presentation/bloc/animal_bloc.dart';
import 'package:app/features/animal/presentation/bloc/animal_event.dart';
import 'package:app/features/choose/presentation/sections/choose_scene_section.dart';

class ChooseAnimalPage extends StatelessWidget {
  const ChooseAnimalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di<AnimalBloc>()..add(const LoadAnimals()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: FittedBox(
            fit: BoxFit.contain,
            child: const ChooseSceneSection(),
          ),
        ),
      ),
    );
  }
}
