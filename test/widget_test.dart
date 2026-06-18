import 'dart:io';

import 'package:calculadora_laboral_mx/app/app.dart';
import 'package:calculadora_laboral_mx/features/calculator/presentation/calculator_screen.dart';
import 'package:calculadora_laboral_mx/features/calculator/presentation/results_screen.dart';
import 'package:calculadora_laboral_mx/features/legal_guide/presentation/legal_guide_screen.dart';
import 'package:calculadora_laboral_mx/features/settings/presentation/legal_notice_screen.dart';
import 'package:calculadora_laboral_mx/features/tools/presentation/extra_tools_screens.dart';
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

  testWidgets('legal guide renders search and topics', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: LegalGuideScreen())),
    );

    expect(find.text('Buscar temas'), findsOneWidget);
    expect(find.text('¿Qué es el finiquito?'), findsOneWidget);
  });

  testWidgets('aguinaldo tool renders result', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: AguinaldoToolScreen())),
    );

    expect(find.text('Calculadora de aguinaldo'), findsOneWidget);
    expect(find.text('Aguinaldo proporcional'), findsOneWidget);
  });

  testWidgets('legal notice states app is not government', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LegalNoticeScreen()));

    expect(find.text('Aviso legal'), findsWidgets);
    expect(
      find.textContaining('no es una entidad gubernamental'),
      findsOneWidget,
    );
  });
}
