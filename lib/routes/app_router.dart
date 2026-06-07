import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/injection/injection.dart';
import 'package:app/features/classification/presentation/bloc/classification_bloc.dart';
import 'package:app/features/drawing/presentation/bloc/drawing_cubit.dart';
import 'package:app/features/drawing/presentation/pages/drawing_page.dart';
import 'package:app/features/drawing/presentation/controllers/drawing_controller.dart';
import 'dart:typed_data';
import 'package:app/features/result/presentation/pages/result_page.dart';
import 'package:app/features/home/presentation/pages/home_page.dart';
import 'package:app/features/choose/presentation/pages/choose_animal_page.dart';
import 'package:app/features/mode/presentation/pages/mode_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/result',
        name: 'result',
        builder: (context, state) {
          final extra = state.extra;
          if (extra is Map<String, dynamic>) {
            final bytes = extra['imageBytes'] as Uint8List?;
            final width = extra['width'] as int?;
            final height = extra['height'] as int?;
            final similarityPercent = extra['similarityPercent'] as double?;
            final selectedAnimal = extra['animal'] as String?;
            final duration = extra['duration'] as int?;
            return ResultPage(
              imageBytes: bytes,
              srcWidth: width,
              srcHeight: height,
              similarityPercent: similarityPercent,
              selectedAnimal: selectedAnimal,
              duration: duration,
            );
          }
          return const ResultPage();
        },
      ),
      GoRoute(
        path: '/drawing',
        name: 'drawing',
        builder: (context, state) {
          final extra = state.extra;
          String? selectedAnimal;
          String? drawingMode;
          if (extra is Map<String, dynamic>) {
            selectedAnimal = extra['animal'] as String?;
            drawingMode = extra['mode'] as String?;
          }
          final controller = di<DrawingController>();
          final drawingCubit = di<DrawingCubit>(param1: controller);
          if (selectedAnimal != null) {
            drawingCubit.setSelectedAnimal(selectedAnimal);
          }
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(value: drawingCubit),
              BlocProvider(create: (_) => di<ClassificationBloc>()),
            ],
            child: DrawingPage(
              selectedAnimal: selectedAnimal,
              drawingMode: drawingMode,
            ),
          );
        },
      ),
      GoRoute(
        path: '/choose',
        name: 'choose',
        builder: (context, state) => const ChooseAnimalPage(),
      ),
      GoRoute(
        path: '/mode',
        name: 'mode',
        builder: (context, state) {
          final extra = state.extra;
          String? animal;
          if (extra is Map<String, dynamic>) {
            animal = extra['animal'] as String?;
          }
          return ModePage(selectedAnimal: animal);
        },
      ),
    ],
    errorBuilder: (context, state) {
      return Scaffold(body: Center(child: Text(state.error.toString())));
    },
  );
}
