import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:awqat/app/theme.dart';
import 'package:awqat/core/theme/cohere_colors.dart';
import 'package:awqat/core/widgets/cohere_settings_widgets.dart';
import 'package:awqat/features/location/domain/city_search_result.dart';
import 'package:awqat/features/location/presentation/location_cubit.dart';
import 'package:awqat/features/location/presentation/location_state.dart';
import 'package:awqat/features/settings/domain/user_location.dart';
import 'package:awqat/features/settings/presentation/settings_cubit.dart';
import 'package:awqat/features/settings/presentation/settings_state.dart';
import 'package:awqat/l10n/app_localizations.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({this.popOnSelect = false, super.key});

  final bool popOnSelect;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final surfPage = CohereColors.surfPage(brightness);
    final statusBarHeight = MediaQuery.of(context).viewPadding.top;

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return Scaffold(
            backgroundColor: surfPage,
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: surfPage,
          body: _LocationBody(
            currentLocation: state.settings.location,
            popOnSelect: popOnSelect,
            statusBarHeight: statusBarHeight,
            brightness: brightness,
          ),
        );
      },
    );
  }
}

class _LocationBody extends StatefulWidget {
  const _LocationBody({
    required this.currentLocation,
    required this.popOnSelect,
    required this.statusBarHeight,
    required this.brightness,
  });

  final UserLocation? currentLocation;
  final bool popOnSelect;
  final double statusBarHeight;
  final Brightness brightness;

  @override
  State<_LocationBody> createState() => _LocationBodyState();
}

class _LocationBodyState extends State<_LocationBody> {
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
    final brightness = widget.brightness;
    final ink = CohereColors.inkColor(brightness);
    final inkDim = CohereColors.inkDim(brightness);
    final inkMute = CohereColors.inkMute(brightness);
    final accent = CohereColors.accentColor(brightness);
    final rule = CohereColors.surfRule(brightness);
    final surfElev = CohereColors.surfElevColor(brightness);

    return MultiBlocListener(
      listeners: [
        BlocListener<LocationCubit, LocationState>(
          listenWhen: (prev, curr) =>
              prev.errorMessage != curr.errorMessage &&
              curr.errorMessage != null,
          listener: (context, state) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
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
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(l10n.highLatitudeHint)));
            }
            _maybePopAfterSelect();
          },
        ),
      ],
      child: BlocBuilder<LocationCubit, LocationState>(
        builder: (context, locationState) {
          final cubit = context.read<LocationCubit>();
          final isBusy =
              locationState.isAcquiringGps || locationState.isSearching;
          final location = widget.currentLocation;
          final hasSearch = _searchController.text.trim().length >= 2;

          return ListView(
            children: [
              SizedBox(height: widget.statusBarHeight + 8),
              // Back button
              Row(
                children: [
                  const SizedBox(width: 4),
                  TextButton.icon(
                    onPressed: () => Navigator.of(context).maybePop(),
                    style: TextButton.styleFrom(
                      foregroundColor: accent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    icon: Icon(
                      Directionality.of(context) == TextDirection.rtl
                          ? Icons.chevron_right
                          : Icons.chevron_left,
                      size: 18,
                    ),
                    label: const Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 4, 24, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SETTINGS',
                      style: cohereMonoLabel(
                        context,
                        fontSize: 11,
                        color: inkMute,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.locationTitle,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ],
                ),
              ),

              // Use device location toggle
              CohereToggleRow(
                label: l10n.useMyLocation,
                sub: l10n.locationUseGpsSubtitle,
                isFirst: true,
                value: locationState.isAcquiringGps,
                onChanged: (v) {
                  if (v && !locationState.isAcquiringGps) {
                    cubit.useCurrentLocation();
                  }
                },
              ),

              // Current / recent location
              if (location != null) ...[
                CohereSectionLabel(label: 'Current'),
                CohereMethodRow(
                  title: location.label ?? l10n.locationUnknown,
                  sub: location.timeZoneId,
                  isSelected: true,
                  isFirst: true,
                  onTap: null,
                ),
              ],

              // Search section
              CohereSectionLabel(label: l10n.locationSearchSectionLabel),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  style: TextStyle(fontSize: 15, color: ink),
                  decoration: InputDecoration(
                    hintText: l10n.searchCityHint,
                    hintStyle: TextStyle(color: inkMute),
                    prefixIcon: Icon(Icons.search, color: inkMute, size: 20),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, color: inkMute, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              cubit.clearSearch();
                              setState(() {});
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: surfElev,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: rule),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: rule),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: accent, width: 1.5),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {});
                    _onSearchChanged(value);
                  },
                ),
              ),

              if (hasSearch) ...[
                const SizedBox(height: 12),
                if (locationState.isSearching)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: accent,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          l10n.locationSearching,
                          style: TextStyle(fontSize: 14, color: inkMute),
                        ),
                      ],
                    ),
                  )
                else if (locationState.searchReturnedEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                    child: Text(
                      l10n.locationSearchNotFoundMessage(
                        _searchController.text.trim(),
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        color: inkMute,
                        height: 1.5,
                      ),
                    ),
                  )
                else if (locationState.searchResults.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        for (
                          var i = 0;
                          i < locationState.searchResults.length;
                          i++
                        )
                          _SearchResultRow(
                            result: locationState.searchResults[i],
                            isFirst: i == 0,
                            enabled: !isBusy,
                            ink: ink,
                            inkMute: inkMute,
                            inkDim: inkDim,
                            rule: rule,
                            onTap: () {
                              _searchController.clear();
                              cubit.clearSearch();
                              cubit.selectSearchResult(
                                locationState.searchResults[i],
                              );
                              setState(() {});
                            },
                          ),
                      ],
                    ),
                  ),
              ],

              const SizedBox(height: 100),
            ],
          );
        },
      ),
    );
  }
}

class _SearchResultRow extends StatelessWidget {
  const _SearchResultRow({
    required this.result,
    required this.isFirst,
    required this.enabled,
    required this.ink,
    required this.inkMute,
    required this.inkDim,
    required this.rule,
    required this.onTap,
  });

  final CitySearchResult result;
  final bool isFirst;
  final bool enabled;
  final Color ink;
  final Color inkMute;
  final Color inkDim;
  final Color rule;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      child: Container(
        decoration: isFirst
            ? null
            : BoxDecoration(
                border: Border(top: BorderSide(color: rule, width: 1)),
              ),
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Icon(Icons.location_on_outlined, color: inkMute, size: 18),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                result.label,
                style: TextStyle(fontSize: 15, color: ink),
              ),
            ),
            Icon(Icons.add, color: inkMute, size: 16),
          ],
        ),
      ),
    );
  }
}
