import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:times/features/settings/presentation/settings_cubit.dart';
import 'package:times/features/settings/presentation/utils/calculation_method_labels.dart';
import 'package:times/l10n/app_localizations.dart';

/// First-run dialog: user must pick a calculation method before continuing.
class InitialSetupDialog extends StatelessWidget {
  const InitialSetupDialog({super.key});

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
                itemCount: kCalculationMethods.length,
                itemBuilder: (context, index) {
                  final (id, label) = kCalculationMethods[index];
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
