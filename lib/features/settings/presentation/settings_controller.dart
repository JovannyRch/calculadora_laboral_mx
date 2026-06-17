import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final themeModeControllerProvider =
    NotifierProvider<ThemeModeController, ThemeMode>(ThemeModeController.new);

class ThemeModeController extends Notifier<ThemeMode> {
  static const _themeModeKey = 'theme_mode';

  Box<dynamic> get _box => Hive.box<dynamic>('app_settings');

  @override
  ThemeMode build() {
    final value = _box.get(_themeModeKey, defaultValue: ThemeMode.system.name);
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == value,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _box.put(_themeModeKey, mode.name);
  }
}
