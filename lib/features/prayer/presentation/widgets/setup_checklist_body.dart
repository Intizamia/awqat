import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:times/core/widgets/settings_grouped_card.dart';
import 'package:times/features/settings/domain/app_settings.dart';
import 'package:times/features/settings/presentation/utils/calculation_method_labels.dart';
import 'package:times/features/settings/presentation/utils/settings_value_labels.dart';
import 'package:times/features/settings/presentation/widgets/settings_group_label.dart';
import 'package:times/features/settings/presentation/widgets/settings_nav_row.dart';
import 'package:times/l10n/app_localizations.dart';

/// Home-screen onboarding checklist until calculation method and location are set.
class SetupChecklistBody extends StatelessWidget {
  const SetupChecklistBody({required this.settings, super.key});

  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final setup = settings.setup;
    final colorScheme = Theme.of(context).colorScheme;
    final calc = settings.calculation;

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 24),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Icon(
                Icons.settings_suggest_outlined,
                size: 64,
                color: colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                l10n.setupRequiredTitle,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.setupRequiredMessage,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        SettingsGroupLabel(label: l10n.setupChecklistGroupLabel),
        SettingsGroupedCard(
          children: [
            Semantics(
              checked: setup.isCalculationConfigured,
              button: true,
              label: l10n.semanticsSetupStep(
                l10n.calculationMethodTitle,
                setup.isCalculationConfigured
                    ? calculationMethodLabel(calc.method)
                    : l10n.chooseCalculationMethod,
              ),
              child: SettingsNavRow(
                icon: setup.isCalculationConfigured
                    ? Icons.check_circle
                    : Icons.calculate_outlined,
                title: l10n.calculationMethodTitle,
                value: setup.isCalculationConfigured
                    ? calculationMethodLabel(calc.method)
                    : l10n.chooseCalculationMethod,
                onTap: () => context.push('/setup/calculation-method'),
              ),
            ),
            Semantics(
              checked: setup.isLocationConfigured,
              button: true,
              label: l10n.semanticsSetupStep(
                l10n.locationTitle,
                locationSummary(l10n, settings.location),
              ),
              child: SettingsNavRow(
                icon: setup.isLocationConfigured
                    ? Icons.check_circle
                    : Icons.place_outlined,
                title: l10n.locationTitle,
                value: locationSummary(l10n, settings.location),
                onTap: () => context.push('/setup/location'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
