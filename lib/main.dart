import 'dart:io';

import 'package:calculadora_laboral_mx/app/app.dart';
import 'package:calculadora_laboral_mx/app/app_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (AppConfig.showAds && _supportsMobileAds) {
    await MobileAds.instance.initialize();
  }

  await initializeDateFormatting('es_MX');
  await Hive.initFlutter();
  await Hive.openBox<dynamic>('app_settings');
  await Hive.openBox<Map<dynamic, dynamic>>('calculation_history');

  runApp(const ProviderScope(child: CalculadoraLaboralMxApp()));
}

bool get _supportsMobileAds =>
    !kIsWeb && (Platform.isAndroid || Platform.isIOS);
