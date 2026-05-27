import 'app_settings.dart';
import 'calculation_settings.dart';
import 'theme_mode_id.dart';

const kDefaultAppSettings = AppSettings(
  calculation: CalculationSettings(),
  localeCode: 'en',
  themeMode: ThemeModeId.system,
);
