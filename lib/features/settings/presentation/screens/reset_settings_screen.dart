import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/cohere_colors.dart';
import '../../../../core/widgets/cohere_settings_widgets.dart';
import '../settings_cubit.dart';
import '../../../../l10n/app_localizations.dart';

class ResetSettingsScreen extends StatelessWidget {
  const ResetSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<SettingsCubit>();

    return CohereDetailScaffold(
      title: l10n.resetSectionTitle,
      intro: l10n.resetSectionSubtitle,
      children: [
        CohereSectionLabel(label: 'Options'),
        _ResetRow(
          label: l10n.resetCalculationTitle,
          sub: l10n.resetCalculationMessage,
          isFirst: true,
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
          label: l10n.resetDisplayTitle,
          sub: l10n.resetDisplayMessage,
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
    required this.label,
    required this.sub,
    required this.onTap,
    this.isFirst = false,
  });

  final String label;
  final String sub;
  final VoidCallback onTap;
  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final ink = CohereColors.inkColor(brightness);
    final inkMute = CohereColors.inkMute(brightness);
    final rule = CohereColors.surfRule(brightness);

    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: isFirst
            ? null
            : BoxDecoration(
                border: Border(top: BorderSide(color: rule, width: 1)),
              ),
        constraints: const BoxConstraints(minHeight: 64),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 15, color: ink, fontFamily: 'Inter'),
            ),
            const SizedBox(height: 4),
            Text(sub, style: TextStyle(fontSize: 13, color: inkMute)),
          ],
        ),
      ),
    );
  }
}
