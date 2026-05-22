import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:times/core/widgets/schedule_groove_divider.dart';
import 'package:times/features/location/presentation/location_cubit.dart';
import 'package:times/features/location/presentation/location_state.dart';
import 'package:times/features/settings/domain/user_location.dart';
import 'package:times/features/settings/presentation/settings_cubit.dart';
import 'package:times/features/settings/presentation/settings_state.dart';
import 'package:times/l10n/app_localizations.dart';

/// Full location editor (GPS, search, clear). Used on the location detail screen.
class LocationSectionBody extends StatefulWidget {
  const LocationSectionBody({
    required this.currentLocation,
    super.key,
  });

  final UserLocation? currentLocation;

  @override
  State<LocationSectionBody> createState() => _LocationSectionBodyState();
}

class _LocationSectionBodyState extends State<LocationSectionBody> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      context.read<LocationCubit>().searchCities(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return MultiBlocListener(
      listeners: [
        BlocListener<LocationCubit, LocationState>(
          listenWhen: (prev, curr) =>
              prev.errorMessage != curr.errorMessage &&
              curr.errorMessage != null,
          listener: (context, state) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          },
        ),
        BlocListener<SettingsCubit, SettingsState>(
          listenWhen: (prev, curr) {
            final p = prev.settings.location;
            final c = curr.settings.location;
            if (c == null) return false;
            if (p == null) return true;
            return p.latitude != c.latitude || p.longitude != c.longitude;
          },
          listener: (context, state) {
            final loc = state.settings.location!;
            if (shouldSuggestHighLatitudeRule(loc)) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.highLatitudeHint)),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<LocationCubit, LocationState>(
        builder: (context, locationState) {
          final cubit = context.read<LocationCubit>();
          final location = widget.currentLocation;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (location != null)
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: const Icon(Icons.place_outlined),
                  title: Text(location.label ?? l10n.locationUnknown),
                  subtitle: Text(
                    '${location.latitude.toStringAsFixed(4)}, '
                    '${location.longitude.toStringAsFixed(4)} · ${location.timeZoneId}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    tooltip: l10n.locationClear,
                    onPressed: locationState.isAcquiringGps ||
                            locationState.isSearching
                        ? null
                        : () => cubit.clearLocation(),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    l10n.locationNotSet,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                ),
              const ScheduleGrooveDivider(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton.tonalIcon(
                  onPressed: locationState.isAcquiringGps
                      ? null
                      : () => cubit.useCurrentLocation(),
                  icon: locationState.isAcquiringGps
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colorScheme.onSecondaryContainer,
                          ),
                        )
                      : const Icon(Icons.my_location),
                  label: Text(
                    locationState.isAcquiringGps
                        ? l10n.locationAcquiring
                        : l10n.useMyLocation,
                  ),
                ),
              ),
              const ScheduleGrooveDivider(),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: l10n.searchCity,
                    hintText: l10n.searchCityHint,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              cubit.clearSearch();
                              setState(() {});
                            },
                          )
                        : locationState.isSearching
                            ? const Padding(
                                padding: EdgeInsets.all(12),
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                ),
                              )
                            : null,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {});
                    _onSearchChanged(value);
                  },
                ),
              ),
              if (locationState.searchResults.isNotEmpty)
                for (var i = 0; i < locationState.searchResults.length; i++) ...[
                  if (i == 0) const ScheduleGrooveDivider(),
                  ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16),
                    leading: const Icon(Icons.location_city),
                    title: Text(locationState.searchResults[i].label),
                    dense: true,
                    onTap: locationState.isSearching
                        ? null
                        : () {
                            _searchController.clear();
                            cubit.clearSearch();
                            cubit.selectSearchResult(
                              locationState.searchResults[i],
                            );
                            setState(() {});
                          },
                  ),
                  if (i < locationState.searchResults.length - 1)
                    const ScheduleGrooveDivider(),
                ],
              const SizedBox(height: 8),
            ],
          );
        },
      ),
    );
  }
}

bool shouldSuggestHighLatitudeRule(UserLocation location) {
  return location.latitude.abs() > 48;
}
