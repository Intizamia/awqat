import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:times/features/location/domain/city_search_result.dart';
import 'package:times/features/location/presentation/location_cubit.dart';
import 'package:times/features/location/presentation/location_state.dart';
import 'package:times/features/settings/domain/user_location.dart';
import 'package:times/features/settings/presentation/settings_cubit.dart';
import 'package:times/features/settings/presentation/settings_state.dart';
import 'package:times/l10n/app_localizations.dart';

/// Location picker: current status, device GPS, and city search.
class LocationScreen extends StatelessWidget {
  const LocationScreen({this.popOnSelect = false, super.key});

  /// When true, pops after the user selects a location (setup flow).
  final bool popOnSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.locationTitle)),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(title: Text(l10n.locationTitle)),
          body: _LocationScreenBody(
            currentLocation: state.settings.location,
            popOnSelect: popOnSelect,
          ),
        );
      },
    );
  }
}

class _LocationScreenBody extends StatefulWidget {
  const _LocationScreenBody({
    required this.currentLocation,
    required this.popOnSelect,
  });

  final UserLocation? currentLocation;
  final bool popOnSelect;

  @override
  State<_LocationScreenBody> createState() => _LocationScreenBodyState();
}

class _LocationScreenBodyState extends State<_LocationScreenBody> {
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
    final trimmed = value.trim();
    if (trimmed.length < 2) {
      context.read<LocationCubit>().clearSearch();
      return;
    }
    context.read<LocationCubit>().beginSearch();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      context.read<LocationCubit>().searchCities(value);
    });
  }

  void _maybePopAfterSelect() {
    if (widget.popOnSelect && mounted && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
            _maybePopAfterSelect();
          },
        ),
      ],
      child: BlocBuilder<LocationCubit, LocationState>(
        builder: (context, locationState) {
          final cubit = context.read<LocationCubit>();
          final location = widget.currentLocation;
          final isBusy =
              locationState.isAcquiringGps || locationState.isSearching;

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              Text(
                l10n.locationSubtitle,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 24),
              _LocationStatusCard(location: location),
              const SizedBox(height: 28),
              Text(
                l10n.locationGetLocationSectionLabel,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.6,
                    ),
              ),
              const SizedBox(height: 10),
              _GpsActionCard(
                isAcquiring: locationState.isAcquiringGps,
                enabled: !isBusy,
                onTap: cubit.useCurrentLocation,
              ),
              const SizedBox(height: 28),
              Text(
                l10n.locationSearchSectionLabel,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.6,
                    ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: l10n.searchCityHint,
                  labelText: l10n.searchCity,
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
                      : null,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onChanged: (value) {
                  setState(() {});
                  _onSearchChanged(value);
                },
              ),
              if (_searchController.text.trim().length >= 2) ...[
                const SizedBox(height: 12),
                if (locationState.isSearching)
                  const _SearchLoadingCard()
                else if (locationState.searchReturnedEmpty)
                  _SearchNotFoundCard(query: _searchController.text.trim())
                else if (locationState.searchResults.isNotEmpty)
                  _SearchResultsCard(
                    results: locationState.searchResults,
                    enabled: !locationState.isSearching,
                    onSelect: (result) {
                      _searchController.clear();
                      cubit.clearSearch();
                      cubit.selectSearchResult(result);
                      setState(() {});
                    },
                  ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _LocationStatusCard extends StatelessWidget {
  const _LocationStatusCard({required this.location});

  final UserLocation? location;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (location == null) {
      return Card(
        elevation: 0,
        color: colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHigh,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.location_off_outlined,
                  size: 28,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.locationNotSet,
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.locationEmptyMessage,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: 0,
      color: colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.check_circle,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.locationCurrentTitle,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.onPrimaryContainer.withValues(
                        alpha: 0.8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    location!.label ?? l10n.locationUnknown,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${location!.latitude.toStringAsFixed(4)}, '
                    '${location!.longitude.toStringAsFixed(4)} · '
                    '${location!.timeZoneId}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onPrimaryContainer.withValues(
                        alpha: 0.75,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            BlocBuilder<LocationCubit, LocationState>(
              builder: (context, locationState) {
                final isBusy = locationState.isAcquiringGps ||
                    locationState.isSearching;
                return IconButton(
                  tooltip: l10n.locationClear,
                  onPressed: isBusy
                      ? null
                      : () => context.read<LocationCubit>().clearLocation(),
                  icon: Icon(
                    Icons.close,
                    color: colorScheme.onPrimaryContainer,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _GpsActionCard extends StatelessWidget {
  const _GpsActionCard({
    required this.isAcquiring,
    required this.enabled,
    required this.onTap,
  });

  final bool isAcquiring;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: enabled ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: isAcquiring
                    ? Padding(
                        padding: const EdgeInsets.all(12),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      )
                    : Icon(
                        Icons.my_location,
                        color: colorScheme.onPrimaryContainer,
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isAcquiring ? l10n.locationAcquiring : l10n.useMyLocation,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.locationUseGpsSubtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isAcquiring)
                Icon(
                  Directionality.of(context) == TextDirection.rtl
                      ? Icons.chevron_left
                      : Icons.chevron_right,
                  color: colorScheme.onSurfaceVariant,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchLoadingCard extends StatelessWidget {
  const _SearchLoadingCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              l10n.locationSearching,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchNotFoundCard extends StatelessWidget {
  const _SearchNotFoundCard({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.search_off_outlined,
              color: colorScheme.onSurfaceVariant,
              size: 28,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.locationSearchNotFoundTitle,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.locationSearchNotFoundMessage(query),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchResultsCard extends StatelessWidget {
  const _SearchResultsCard({
    required this.results,
    required this.enabled,
    required this.onSelect,
  });

  final List<CitySearchResult> results;
  final bool enabled;
  final void Function(CitySearchResult result) onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < results.length; i++) ...[
            if (i > 0) Divider(height: 1, color: colorScheme.outlineVariant),
            ListTile(
              leading: Icon(Icons.location_city, color: colorScheme.primary),
              title: Text(results[i].label),
              trailing: const Icon(Icons.add_location_alt_outlined),
              enabled: enabled,
              onTap: enabled ? () => onSelect(results[i]) : null,
            ),
          ],
        ],
      ),
    );
  }
}
