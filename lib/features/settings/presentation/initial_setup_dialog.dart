import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:times/features/settings/domain/calculation_method_id.dart';
import 'package:times/features/settings/presentation/settings_cubit.dart';
import 'package:times/l10n/app_localizations.dart';

/// First-run dialog: user must pick a calculation method before continuing.
class InitialSetupDialog extends StatelessWidget {
  const InitialSetupDialog({super.key});

  static const _methods = <(CalculationMethodId, String)>[
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.initialSetupTitle),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.initialSetupMessage),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: _methods.length,
                itemBuilder: (context, index) {
                  final (id, label) = _methods[index];
                  return ListTile(
                    title: Text(label),
                    onTap: () async {
                      await context.read<SettingsCubit>().setCalculationMethod(id);
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
