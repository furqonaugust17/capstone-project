import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'injection/injection.dart';
import 'routes/app_router.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter.router;
    return BlocProvider<AuthBloc>(
      create: (_) => di<AuthBloc>()..add(const AuthCheckRequested()),
      child: MaterialApp.router(
        title: 'Educational Animal Drawing',
        theme: AppTheme.light(),
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
