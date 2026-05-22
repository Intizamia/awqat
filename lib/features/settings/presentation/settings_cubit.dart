import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:times/features/settings/data/settings_repository.dart';
import 'package:times/features/settings/domain/calculation_method_id.dart';
import 'package:times/features/settings/presentation/settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._repository) : super(const SettingsState());

  final SettingsRepository _repository;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true));
    final settings = _repository.load();
    emit(SettingsState(settings: settings, isLoading: false));
  }

  Future<void> setLocale(String code) async {
    final updated = state.settings.copyWith(localeCode: code);
    await _repository.save(updated);
    emit(state.copyWith(settings: updated));
  }

  Future<void> setCalculationMethod(CalculationMethodId method) async {
    await _repository.setCalculationMethod(method);
    await load();
  }

  Future<void> setLocationConfigured(bool value) async {
    await _repository.setLocationConfigured(value);
    await load();
  }
}
