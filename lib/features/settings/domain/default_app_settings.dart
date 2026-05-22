import 'package:times/features/settings/domain/app_settings.dart';
import 'package:times/features/settings/domain/calculation_settings.dart';
import 'package:times/features/settings/domain/theme_mode_id.dart';

const kDefaultAppSettings = AppSettings(
  calculation: CalculationSettings(),
  localeCode: 'en',
  themeMode: ThemeModeId.system,
);
