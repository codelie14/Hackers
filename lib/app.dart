import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/splash_screen.dart';

class HackersApp extends ConsumerWidget {
  const HackersApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Hackers — Offline Security Toolkit',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const SplashScreen(), // Add splash screen as initial route
      routerConfig: appRouter,
    );
  }
}
