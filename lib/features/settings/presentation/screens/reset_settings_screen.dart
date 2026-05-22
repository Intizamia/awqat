import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:times/core/widgets/settings_grouped_card.dart';
import 'package:times/features/settings/presentation/settings_cubit.dart';
import 'package:times/features/settings/presentation/widgets/settings_detail_scaffold.dart';
import 'package:times/features/settings/presentation/widgets/settings_row_metrics.dart';
import 'package:times/l10n/app_localizations.dart';

class ResetSettingsScreen extends StatelessWidget {
  const ResetSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<SettingsCubit>();

    return SettingsDetailScaffold(
      title: l10n.resetSectionTitle,
      subtitle: l10n.resetSectionSubtitle,
      slivers: [
        SettingsGroupedCardSliver(
          child: SettingsGroupedCard(
            children: [
              _ResetRow(
                title: l10n.resetCalculationTitle,
                subtitle: l10n.resetCalculationMessage,
                onTap: () async {
                  final confirmed = await _confirm(
                    context,
                    l10n.resetCalculationTitle,
                    l10n.resetCalculationMessage,
                    l10n,
                  );
                  if (confirmed == true && context.mounted) {
                    await cubit.resetCalculationToDefaults();
                  }
                },
              ),
              _ResetRow(
                title: l10n.resetDisplayTitle,
                subtitle: l10n.resetDisplayMessage,
                onTap: () async {
                  final confirmed = await _confirm(
                    context,
                    l10n.resetDisplayTitle,
                    l10n.resetDisplayMessage,
                    l10n,
                  );
                  if (confirmed == true && context.mounted) {
                    await cubit.resetToDefaults();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<bool?> _confirm(
    BuildContext context,
    String title,
    String message,
    AppLocalizations l10n,
  ) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
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
  }
}

class _ResetRow extends StatelessWidget {
  const _ResetRow({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: SettingsRowMetrics.minHeight,
        ),
        child: Padding(
          padding: SettingsRowMetrics.contentPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: theme.textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
