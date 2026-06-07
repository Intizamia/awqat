import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/adhan_calculation_engine.dart';
import 'prayer_times_state.dart';
import '../../settings/domain/app_settings.dart';
import '../../widgets/widget_data_writer.dart';

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
      WidgetDataWriter.update(schedule: schedule, settings: settings);
    } catch (e) {
      emit(PrayerTimesState(isLoading: false, errorMessage: e.toString()));
    }
  }
}
