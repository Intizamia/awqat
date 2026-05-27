import 'package:equatable/equatable.dart';
import 'package:awqat/features/settings/domain/app_settings.dart';

class SettingsState extends Equatable {
  const SettingsState({
    this.settings = const AppSettings(),
    this.isLoading = true,
  });

  final AppSettings settings;
  final bool isLoading;

  SettingsState copyWith({AppSettings? settings, bool? isLoading}) {
    return SettingsState(
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [settings, isLoading];
}
