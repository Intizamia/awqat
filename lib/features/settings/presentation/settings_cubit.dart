import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/settings_repository.dart';
import '../domain/app_settings.dart';
import '../../prayer/domain/prayer_name.dart';
import '../../prayer/domain/prayer_notif_type.dart';
import '../domain/calculation_method_id.dart';
import '../domain/calculation_settings.dart';
import '../domain/default_app_settings.dart';
import '../domain/theme_mode_id.dart';
import '../domain/time_format_id.dart';
import '../domain/user_location.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._repository) : super(const SettingsState());

  final SettingsRepository _repository;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true));
    final settings = _repository.load();
    emit(SettingsState(settings: settings, isLoading: false));
  }

  Future<void> _save(AppSettings settings) async {
    await _repository.save(settings);
    emit(state.copyWith(settings: settings));
  }

  Future<void> setLocale(String code) async {
    await _save(state.settings.copyWith(localeCode: code));
  }

  Future<void> setThemeMode(ThemeModeId mode) async {
    await _save(state.settings.copyWith(themeMode: mode));
  }

  Future<void> setTimeFormat(TimeFormatId format) async {
    await _save(state.settings.copyWith(timeFormat: format));
  }

  Future<void> setHijriAdjustmentDays(int days) async {
    final clamped = days.clamp(-2, 2);
    await _save(state.settings.copyWith(hijriAdjustmentDays: clamped));
  }

  Future<void> setShowSunrise(bool value) async {
    await _save(state.settings.copyWith(showSunrise: value));
  }

  Future<void> setNotificationsEnabled(bool value) async {
    await _save(
      state.settings.copyWith(
        notifications: state.settings.notifications.copyWith(enabled: value),
      ),
    );
  }

  Future<void> setPreReminderEnabled(bool value) async {
    await _save(
      state.settings.copyWith(
        notifications: state.settings.notifications.copyWith(
          preReminderEnabled: value,
        ),
      ),
    );
  }

  Future<void> setPreReminderMinutes(int minutes) async {
    await _save(
      state.settings.copyWith(
        notifications: state.settings.notifications.copyWith(
          preReminderMinutes: minutes,
        ),
      ),
    );
  }

  Future<void> setPrayerNotificationEnabled(
    PrayerName prayer,
    bool value,
  ) async {
    await _save(
      state.settings.copyWith(
        notifications: state.settings.notifications.copyWithPrayer(
          prayer,
          value,
        ),
      ),
    );
  }

  Future<void> setPrayerNotifType(PrayerName prayer, PrayerNotifType type) async {
    await _save(
      state.settings.copyWith(
        notifications: state.settings.notifications.copyWithNotifType(prayer, type),
      ),
    );
  }

  Future<void> setCalculationMethod(CalculationMethodId method) async {
    await updateCalculation(
      state.settings.calculation.copyWith(method: method),
    );
  }

  Future<void> updateCalculation(CalculationSettings calculation) async {
    await _save(state.settings.copyWith(calculation: calculation));
  }

  Future<void> setLocation(UserLocation location) async {
    await _save(state.settings.copyWith(location: location));
  }

  Future<void> clearLocation() async {
    await _save(state.settings.copyWith(clearLocation: true));
  }

  Future<void> resetToDefaults() async {
    final location = state.settings.location;
    await _save(
      kDefaultAppSettings.copyWith(
        location: location,
        calculation: state.settings.calculation.copyWith(
          method: state.settings.calculation.method,
        ),
      ),
    );
  }

  Future<void> resetCalculationToDefaults() async {
    final method = state.settings.calculation.method;
    await updateCalculation(
      const CalculationSettings().copyWith(method: method),
    );
  }
}
