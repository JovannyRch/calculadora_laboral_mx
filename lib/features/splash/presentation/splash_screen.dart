import 'dart:async';

import 'package:calculadora_laboral_mx/core/constants/app_colors.dart';
import 'package:calculadora_laboral_mx/features/home/presentation/home_screen.dart';
import 'package:calculadora_laboral_mx/features/onboarding/data/onboarding_repository.dart';
import 'package:calculadora_laboral_mx/features/onboarding/presentation/onboarding_screen.dart';
import 'package:calculadora_laboral_mx/shared/extensions/context_extensions.dart';
import 'package:calculadora_laboral_mx/shared/widgets/app_icon_mark.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  static const routeName = 'splash';
  static const routePath = '/splash';

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1100), _navigate);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _navigate() {
    if (!mounted) return;

    final repository = ref.read(onboardingRepositoryProvider);
    final destination = repository.isCompleted
        ? HomeScreen.routePath
        : OnboardingScreen.routePath;

    context.go(destination);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: context.isDark
                ? const [AppColors.darkBackground, AppColors.darkSurface]
                : const [AppColors.navy, Color(0xFF123B68)],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppIconMark(size: 88),
                const SizedBox(height: 24),
                Text(
                  'Calculadora Laboral MX',
                  textAlign: TextAlign.center,
                  style: context.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Finiquito y liquidacion con claridad',
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: 120,
                  child: LinearProgressIndicator(
                    minHeight: 3,
                    borderRadius: BorderRadius.circular(999),
                    color: Colors.white,
                    backgroundColor: Colors.white24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
