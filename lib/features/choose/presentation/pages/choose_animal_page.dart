import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/injection/injection.dart';
import 'package:app/features/animal/presentation/bloc/animal_bloc.dart';
import 'package:app/features/animal/presentation/bloc/animal_event.dart';
import 'package:app/features/choose/presentation/sections/choose_scene_section.dart';

import 'package:app/shared/widgets/custom_app_bar.dart';

class ChooseAnimalPage extends StatelessWidget {
  const ChooseAnimalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di<AnimalBloc>()..add(const LoadAnimals()),
      child: Scaffold(
        appBar: const CustomAppBar(title: 'HEWAN'),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Center(child: ChooseSceneSection()),
        ),
      ),
    );
  }
}
