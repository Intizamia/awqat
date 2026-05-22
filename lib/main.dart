import 'package:flutter/material.dart';
import 'package:times/app/app.dart';
import 'package:times/features/settings/data/settings_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settingsRepository = await SettingsRepository.create();
  runApp(TimesApp(settingsRepository: settingsRepository));
}
