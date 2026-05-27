import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:awqat/features/prayer/data/adhan_calculation_engine.dart';
import 'package:awqat/features/prayer/presentation/prayer_times_state.dart';
import 'package:awqat/features/settings/domain/app_settings.dart';

class PrayerTimesCubit extends Cubit<PrayerTimesState> {
  PrayerTimesCubit(this._engine) : super(const PrayerTimesState());

  final AdhanCalculationEngine _engine;

  void refresh(AppSettings settings) {
    if (!settings.setup.isComplete || settings.location == null) {
      emit(const PrayerTimesState());
      return;
    }

    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final schedule = _engine.compute(
        date: DateTime.now(),
        location: settings.location!,
        calculation: settings.calculation,
      );
      emit(PrayerTimesState(schedule: schedule, isLoading: false));
    } catch (e) {
      emit(PrayerTimesState(isLoading: false, errorMessage: e.toString()));
    }
  }
}
