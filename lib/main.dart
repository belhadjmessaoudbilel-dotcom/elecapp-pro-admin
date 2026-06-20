import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:elecapp_core/elecapp_core.dart';

import 'screens/auth/splash_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await SupabaseConfig.initialize();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const ElecApp());
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (ctx, st) => const SplashScreen()),
    GoRoute(path: '/login', builder: (ctx, st) => const LoginScreen()),
    GoRoute(path: '/register', builder: (ctx, st) => const RegisterScreen()),
    GoRoute(path: '/forgot-password', builder: (ctx, st) => const ForgotPasswordScreen()),
    GoRoute(path: '/dashboard', builder: (ctx, st) => const DashboardScreen()),
  ],
);

class ElecApp extends StatelessWidget {
  const ElecApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    title: 'Elecapp Admin',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    routerConfig: _router,
  );
}
