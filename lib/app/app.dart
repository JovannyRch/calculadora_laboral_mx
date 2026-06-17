import 'package:calculadora_laboral_mx/app/router.dart';
import 'package:calculadora_laboral_mx/app/theme.dart';
import 'package:calculadora_laboral_mx/features/settings/presentation/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalculadoraLaboralMxApp extends ConsumerWidget {
  const CalculadoraLaboralMxApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeControllerProvider);

    return MaterialApp.router(
      title: 'Calculadora Laboral MX',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
