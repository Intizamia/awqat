import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:times/features/settings/domain/setup_completion_status.dart';
import 'package:times/features/settings/presentation/settings_state.dart';

/// App-wide settings and setup completion (persistence in Phase 1).
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  void setLocale(String code) {
    emit(state.copyWith(localeCode: code));
  }

  void updateSetup(SetupCompletionStatus setup) {
    emit(state.copyWith(setup: setup));
  }

  /// Temporary helpers until SettingsRepository exists (Phase 1).
  void markCalculationConfigured() {
    emit(
      state.copyWith(
        setup: state.setup.copyWith(isCalculationConfigured: true),
      ),
    );
  }

  void markLocationConfigured() {
    emit(
      state.copyWith(
        setup: state.setup.copyWith(isLocationConfigured: true),
      ),
    );
  }
}
