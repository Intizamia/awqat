import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:times/features/settings/presentation/settings_cubit.dart';
import 'package:times/l10n/app_localizations.dart';

class SettingsResetSection extends StatelessWidget {
  const SettingsResetSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<SettingsCubit>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OutlinedButton(
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(l10n.resetCalculationTitle),
                  content: Text(l10n.resetCalculationMessage),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: Text(l10n.cancel),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: Text(l10n.reset),
                    ),
                  ],
                ),
              );
              if (confirmed == true && context.mounted) {
                await cubit.resetCalculationToDefaults();
              }
            },
            child: Text(l10n.resetCalculationTitle),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(l10n.resetDisplayTitle),
                  content: Text(l10n.resetDisplayMessage),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: Text(l10n.cancel),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: Text(l10n.reset),
                    ),
                  ],
                ),
              );
              if (confirmed == true && context.mounted) {
                await cubit.resetToDefaults();
              }
            },
            child: Text(l10n.resetDisplayTitle),
          ),
        ],
      ),
    );
  }
}
