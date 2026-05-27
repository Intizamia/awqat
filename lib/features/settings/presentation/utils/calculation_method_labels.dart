import '../../domain/calculation_method_id.dart';

const kCalculationMethods = <(CalculationMethodId, String)>[
  (CalculationMethodId.muslimWorldLeague, 'Muslim World League'),
  (CalculationMethodId.karachi, 'University of Islamic Sciences, Karachi'),
  (CalculationMethodId.northAmerica, 'ISNA (North America)'),
  (CalculationMethodId.ummAlQura, 'Umm Al-Qura, Makkah'),
  (CalculationMethodId.egyptian, 'Egyptian General Authority'),
  (CalculationMethodId.dubai, 'Dubai'),
  (CalculationMethodId.qatar, 'Qatar'),
  (CalculationMethodId.kuwait, 'Kuwait'),
  (CalculationMethodId.singapore, 'Singapore (MUIS)'),
  (CalculationMethodId.tehran, 'Tehran'),
  (CalculationMethodId.turkey, 'Turkey (Diyanet)'),
  (CalculationMethodId.moonsightingCommittee, 'Moonsighting Committee'),
  (CalculationMethodId.other, 'Custom'),
];

String calculationMethodLabel(CalculationMethodId? id) {
  if (id == null) return '—';
  for (final entry in kCalculationMethods) {
    if (entry.$1 == id) return entry.$2;
  }
  return id.name;
}
