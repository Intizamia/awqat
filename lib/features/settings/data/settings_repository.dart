import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:awqat/features/settings/domain/app_settings.dart';
import 'package:awqat/features/settings/domain/calculation_method_id.dart';
import 'package:awqat/features/settings/domain/theme_mode_id.dart';
import 'package:awqat/features/settings/domain/user_location.dart';

const _kSettingsKey = 'app_settings_v1';

class SettingsRepository {
  SettingsRepository(this._prefs);

  final SharedPreferences _prefs;

  static Future<SettingsRepository> create() async {
    final prefs = await SharedPreferences.getInstance();
    return SettingsRepository(prefs);
  }

  AppSettings load() {
    final raw = _prefs.getString(_kSettingsKey);
    if (raw == null) {
      return const AppSettings();
    }
    try {
      return AppSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return const AppSettings();
    }
  }

  Future<void> save(AppSettings settings) async {
    await _prefs.setString(_kSettingsKey, jsonEncode(settings.toJson()));
  }

  Future<void> setCalculationMethod(CalculationMethodId method) async {
    final current = load();
    await save(
      current.copyWith(
        calculation: current.calculation.copyWith(method: method),
      ),
    );
  }

  Future<void> setLocation(UserLocation? location) async {
    final current = load();
    await save(
      current.copyWith(location: location, clearLocation: location == null),
    );
  }

  Future<void> setThemeMode(ThemeModeId mode) async {
    final current = load();
    await save(current.copyWith(themeMode: mode));
  }
}
