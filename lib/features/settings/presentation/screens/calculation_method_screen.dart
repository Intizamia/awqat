import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:awqat/core/widgets/cohere_settings_widgets.dart';
import 'package:awqat/features/settings/domain/calculation_method_id.dart';
import 'package:awqat/features/settings/presentation/settings_cubit.dart';
import 'package:awqat/features/settings/presentation/settings_state.dart';
import 'package:awqat/features/settings/presentation/utils/calculation_method_labels.dart';
import 'package:awqat/l10n/app_localizations.dart';

const _kMethodDescriptions = <CalculationMethodId, String>{
  CalculationMethodId.muslimWorldLeague:
      'Standard for general use, Europe and Far East.',
  CalculationMethodId.karachi: 'Pakistan, Bangladesh, India, Afghanistan.',
  CalculationMethodId.northAmerica: 'Islamic Society of North America.',
  CalculationMethodId.ummAlQura: 'Saudi Arabia. 90 min Isha after Maghrib.',
  CalculationMethodId.egyptian: 'Used in Africa, Syria, Lebanon, Malaysia.',
  CalculationMethodId.dubai: 'UAE — Dubai.',
  CalculationMethodId.qatar: 'Qatar.',
  CalculationMethodId.kuwait: 'Kuwait.',
  CalculationMethodId.singapore: 'Majlis Ugama Islam Singapura.',
  CalculationMethodId.tehran: 'Institute of Geophysics, Tehran.',
  CalculationMethodId.turkey: 'Diyanet İşleri Başkanlığı.',
  CalculationMethodId.moonsightingCommittee:
      'Shaykh Hamza Yusuf. Astronomically calibrated.',
  CalculationMethodId.other: 'Manually set Fajr and Isha angles.',
};

class CalculationMethodScreen extends StatelessWidget {
  const CalculationMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final method = state.settings.calculation.method;
        final cubit = context.read<SettingsCubit>();

        return CohereDetailScaffold(
          title: l10n.calculationMethodTitle,
          intro: l10n.calculationMethodSubtitle,
          children: [
            CohereSectionLabel(label: 'Choose authority'),
            for (final (id, label) in kCalculationMethods)
              CohereMethodRow(
                title: label,
                sub: _kMethodDescriptions[id],
                isSelected: method == id,
                isFirst: id == kCalculationMethods.first.$1,
                onTap: () => cubit.setCalculationMethod(id),
              ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Methods differ primarily in their Fajr and Isha angles. '
                'Switching method recalculates all prayer times for your '
                'current location.',
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
