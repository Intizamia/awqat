import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:times/core/widgets/settings_grouped_card.dart';
import 'package:times/features/location/presentation/location_section.dart';
import 'package:times/features/settings/presentation/settings_cubit.dart';
import 'package:times/features/settings/presentation/settings_state.dart';
import 'package:times/features/settings/presentation/widgets/settings_detail_scaffold.dart';
import 'package:times/l10n/app_localizations.dart';

class LocationSettingsScreen extends StatelessWidget {
  const LocationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return SettingsDetailScaffold(
            title: l10n.locationTitle,
            subtitle: l10n.locationSubtitle,
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        return SettingsDetailScaffold(
          title: l10n.locationTitle,
          subtitle: l10n.locationSubtitle,
          body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: [
              SettingsGroupedCard(
                children: [
                  LocationSectionBody(currentLocation: state.settings.location),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
