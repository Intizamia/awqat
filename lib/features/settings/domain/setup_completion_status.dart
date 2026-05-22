import 'package:equatable/equatable.dart';

/// Whether the user has completed minimum setup for prayer times.
class SetupCompletionStatus extends Equatable {
  const SetupCompletionStatus({
    this.isCalculationConfigured = false,
    this.isLocationConfigured = false,
  });

  final bool isCalculationConfigured;
  final bool isLocationConfigured;

  bool get isComplete => isCalculationConfigured && isLocationConfigured;

  SetupCompletionStatus copyWith({
    bool? isCalculationConfigured,
    bool? isLocationConfigured,
  }) {
    return SetupCompletionStatus(
      isCalculationConfigured:
          isCalculationConfigured ?? this.isCalculationConfigured,
      isLocationConfigured: isLocationConfigured ?? this.isLocationConfigured,
    );
  }

  @override
  List<Object?> get props => [isCalculationConfigured, isLocationConfigured];
}
