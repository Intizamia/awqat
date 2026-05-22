import 'package:equatable/equatable.dart';
import 'package:times/features/settings/domain/setup_completion_status.dart';

class SettingsState extends Equatable {
  const SettingsState({
    this.setup = const SetupCompletionStatus(),
    this.localeCode = 'en',
  });

  final SetupCompletionStatus setup;
  final String localeCode;

  SettingsState copyWith({
    SetupCompletionStatus? setup,
    String? localeCode,
  }) {
    return SettingsState(
      setup: setup ?? this.setup,
      localeCode: localeCode ?? this.localeCode,
    );
  }

  @override
  List<Object?> get props => [setup, localeCode];
}
