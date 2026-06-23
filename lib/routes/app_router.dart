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
import 'package:app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:app/features/auth/presentation/bloc/auth_state.dart';
import 'package:app/features/auth/presentation/pages/login_page.dart';
import 'package:app/features/auth/presentation/pages/register_page.dart';
import 'package:app/features/splash/presentation/pages/splash_page.dart';
import 'package:app/features/game_session/presentation/bloc/submit/submit_game_cubit.dart';
import 'package:app/features/game_session/presentation/bloc/history/history_cubit.dart';
import 'package:app/features/game_session/presentation/bloc/detail/session_detail_cubit.dart';
import 'package:app/features/game_session/presentation/pages/history_page.dart';
import 'package:app/features/game_session/presentation/pages/session_detail_page.dart';
import 'package:app/features/game_session/presentation/pages/session_detail_page.dart';
import 'package:app/features/leaderboard/presentation/bloc/leaderboard_cubit.dart';
import 'package:app/features/leaderboard/presentation/pages/leaderboard_page.dart';
import 'package:app/features/statistics/presentation/pages/statistics_page.dart';
import 'package:app/features/shop/presentation/pages/shop_page.dart';
import 'package:app/features/shop/presentation/pages/shop_item_detail_page.dart';
import 'package:app/features/shop/domain/entities/shop_item_entity.dart';
import 'package:app/features/inventory/presentation/pages/inventory_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final authState = context.read<AuthBloc>().state;
      final isAuthenticated = authState is Authenticated;
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';
      final isSplashRoute = state.matchedLocation == '/splash';

      if (isSplashRoute) return null;
      if (!isAuthenticated && !isAuthRoute) return '/login';
      if (isAuthenticated && isAuthRoute) return '/';
      return null;
    },
    routes: <GoRoute>[
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
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
            final selectedAnimal = extra['animal'];
            final duration = extra['duration'] as int?;
            final predictionLabel = extra['predictionLabel'] as String?;
            final confidenceScore = extra['confidenceScore'] as double?;
            final startedAt = extra['startedAt'] as DateTime?;

            return BlocProvider(
              create: (context) => di<SubmitGameCubit>(),
              child: ResultPage(
                imageBytes: bytes,
                srcWidth: width,
                srcHeight: height,
                similarityPercent: similarityPercent,
                selectedAnimal: selectedAnimal,
                duration: duration,
                predictionLabel: predictionLabel,
                confidenceScore: confidenceScore,
                startedAt: startedAt,
              ),
            );
          }
          return BlocProvider(
            create: (context) => di<SubmitGameCubit>(),
            child: const ResultPage(),
          );
        },
      ),
      GoRoute(
        path: '/drawing',
        name: 'drawing',
        builder: (context, state) {
          final extra = state.extra;
          dynamic selectedAnimal;
          String? drawingMode;
          if (extra is Map<String, dynamic>) {
            selectedAnimal = extra['animal'];
            drawingMode = extra['mode'] as String?;
          }
          final controller = di<DrawingController>();
          final drawingCubit = di<DrawingCubit>(param1: controller);
          if (selectedAnimal != null) {
            // we will extract name from entity in drawing page
            drawingCubit.setSelectedAnimal(selectedAnimal.name);
          }
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(value: drawingCubit),
              BlocProvider(create: (_) => di<ClassificationBloc>()),
            ],
            child: DrawingPage(
              selectedAnimalEntity: selectedAnimal, // Need to update DrawingPage to accept this
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
          dynamic animal;
          if (extra is Map<String, dynamic>) {
            animal = extra['animal'];
          }
          return ModePage(selectedAnimal: animal); // Pass the entity directly
        },
      ),
      GoRoute(
        path: '/history',
        name: 'history',
        builder: (context, state) => BlocProvider(
          create: (context) => di<HistoryCubit>(),
          child: const HistoryPage(),
        ),
        routes: [
          GoRoute(
            path: ':id',
            name: 'history_detail',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return BlocProvider(
                create: (context) => di<SessionDetailCubit>(),
                child: SessionDetailPage(sessionId: id),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '/leaderboard',
        name: 'leaderboard',
        builder: (context, state) => BlocProvider(
          create: (context) => di<LeaderboardCubit>(),
          child: const LeaderboardPage(),
        ),
      ),
      GoRoute(
        path: '/statistics',
        name: 'statistics',
        builder: (context, state) => const StatisticsPage(),
      ),
      GoRoute(
        path: '/shop',
        name: 'shop',
        builder: (context, state) => const ShopPage(),
      ),
      GoRoute(
        path: '/inventory',
        name: 'inventory',
        builder: (context, state) => const InventoryPage(),
      ),
      GoRoute(
        path: '/shop/:id',
        name: 'shop_detail',
        builder: (context, state) {
          final item = state.extra as ShopItemEntity;
          return ShopItemDetailPage(item: item);
        },
      ),
    ],
    errorBuilder: (context, state) {
      return Scaffold(body: Center(child: Text(state.error.toString())));
    },
  );
}
