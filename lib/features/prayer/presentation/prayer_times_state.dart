import 'package:equatable/equatable.dart';
import 'package:awqat/features/prayer/domain/prayer_schedule.dart';

class PrayerTimesState extends Equatable {
  const PrayerTimesState({
    this.schedule,
    this.isLoading = false,
    this.errorMessage,
  });

  final PrayerSchedule? schedule;
  final bool isLoading;
  final String? errorMessage;

  PrayerTimesState copyWith({
    PrayerSchedule? schedule,
    bool? isLoading,
    String? errorMessage,
    bool clearSchedule = false,
    bool clearError = false,
  }) {
    return PrayerTimesState(
      schedule: clearSchedule ? null : (schedule ?? this.schedule),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [schedule, isLoading, errorMessage];
}
