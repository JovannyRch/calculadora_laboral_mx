import 'dart:io';

import 'package:calculadora_laboral_mx/app/app.dart';
import 'package:calculadora_laboral_mx/features/calculator/presentation/calculator_screen.dart';
import 'package:calculadora_laboral_mx/features/calculator/presentation/results_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final tempDirectory = await Directory.systemTemp.createTemp('clmx_test_');
    Hive.init(tempDirectory.path);
    await Hive.openBox<dynamic>('app_settings');
    await Hive.openBox<Map<dynamic, dynamic>>('calculation_history');
  });

  testWidgets('renders app shell', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: CalculadoraLaboralMxApp()),
    );
    await tester.pump();

    expect(find.text('Calculadora Laboral MX'), findsOneWidget);
  });

  testWidgets('calculator wizard advances from type to dates', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: CalculatorScreen())),
    );

    expect(find.text('Tipo de calculo'), findsOneWidget);

    await tester.tap(find.text('Siguiente'));
    await tester.pumpAndSettle();

    expect(find.text('Fechas laborales'), findsOneWidget);
  });

  testWidgets('results screen renders dashboard total', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: ResultsScreen())),
    );

    expect(find.text('Resultado estimado'), findsOneWidget);
    expect(find.text('Total neto'), findsOneWidget);
  });
}
