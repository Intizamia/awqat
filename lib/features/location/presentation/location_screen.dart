import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../core/theme/cohere_colors.dart';
import '../../../core/widgets/cohere_settings_widgets.dart';
import 'location_cubit.dart';
import 'location_state.dart';
import 'location_search_screen.dart';
import 'location_manual_screen.dart';
import 'location_cities_screen.dart';
import '../../settings/domain/user_location.dart';
import '../../settings/presentation/settings_cubit.dart';
import '../../settings/presentation/settings_state.dart';
import '../../../l10n/app_localizations.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({
    this.popOnSelect = false,
    this.backLabel = 'Settings',
    super.key,
  });

  final bool popOnSelect;
  final String backLabel;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final surfPage = CohereColors.surfPage(brightness);

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settingsState) {
        if (settingsState.isLoading) {
          return Scaffold(
            backgroundColor: surfPage,
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        return BlocListener<SettingsCubit, SettingsState>(
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
                SnackBar(content: Text(AppLocalizations.of(context)!.highLatitudeHint)),
              );
            }
            if (popOnSelect && Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
          child: Scaffold(
            backgroundColor: surfPage,
            body: _LocationHub(
              currentLocation: settingsState.settings.location,
              backLabel: backLabel,
              brightness: brightness,
              surfPage: surfPage,
            ),
          ),
        );
      },
    );
  }
}

class _LocationHub extends StatelessWidget {
  const _LocationHub({
    required this.currentLocation,
    required this.backLabel,
    required this.brightness,
    required this.surfPage,
  });

  final UserLocation? currentLocation;
  final String backLabel;
  final Brightness brightness;
  final Color surfPage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ink = CohereColors.inkColor(brightness);
    final inkMute = CohereColors.inkMute(brightness);
    final inkDim = CohereColors.inkDim(brightness);
    final accent = CohereColors.accentColor(brightness);
    final rule = CohereColors.surfRule(brightness);
    final surfElev = CohereColors.surfElevColor(brightness);
    final statusBarHeight = MediaQuery.of(context).viewPadding.top;
    final cubit = context.read<LocationCubit>();

    return BlocListener<LocationCubit, LocationState>(
      listenWhen: (prev, curr) =>
          prev.errorMessage != curr.errorMessage && curr.errorMessage != null,
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.errorMessage!)),
        );
      },
      child: BlocBuilder<LocationCubit, LocationState>(
        builder: (context, locationState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sticky header
            ColoredBox(
              color: surfPage,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: statusBarHeight * 2 + 8),
                  Row(
                    children: [
                      const SizedBox(width: 4),
                      TextButton.icon(
                        onPressed: () => context.pop(),
                        style: TextButton.styleFrom(
                          foregroundColor: accent,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        icon: Icon(
                          Directionality.of(context) == TextDirection.rtl
                              ? Icons.chevron_right
                              : Icons.chevron_left,
                          size: 18,
                        ),
                        label: Text(
                          backLabel,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 4, 24, 22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          backLabel.toUpperCase(),
                          style: cohereMonoLabel(context, fontSize: 11, color: inkMute),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.locationTitle,
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Scrollable content
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Current location card
                  if (currentLocation != null) ...[
                    CohereSectionLabel(label: 'Current Location'),
                    _CurrentLocationCard(
                      location: currentLocation!,
                      isResolvingName: locationState.isResolvingName,
                      ink: ink,
                      inkMute: inkMute,
                      inkDim: inkDim,
                      rule: rule,
                      surfElev: surfElev,
                      accent: accent,
                      onClear: () => cubit.clearLocation(),
                    ),
                  ],

                  CohereSectionLabel(label: 'Set Location'),
                  // 1. GPS
                  _OptionRow(
                    icon: Icons.my_location,
                    label: 'Detect from GPS',
                    sub: 'Offline — uses device hardware',
                    isFirst: true,
                    trailing: locationState.isAcquiringGps
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: accent),
                          )
                        : null,
                    rule: rule,
                    ink: ink,
                    inkMute: inkMute,
                    onTap: locationState.isAcquiringGps
                        ? null
                        : () => cubit.useCurrentLocation(),
                  ),
                  // 2. Cities Directory
                  _OptionRow(
                    icon: Icons.location_city_outlined,
                    label: 'Cities Directory',
                    sub: 'Offline — browse major cities by country',
                    rule: rule,
                    ink: ink,
                    inkMute: inkMute,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: cubit,
                          child: const LocationCitiesScreen(),
                        ),
                      ),
                    ),
                  ),
                  // 3. Search
                  _OptionRow(
                    icon: Icons.search,
                    label: 'Search Location',
                    sub: 'Online — search by city or place name',
                    rule: rule,
                    ink: ink,
                    inkMute: inkMute,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: cubit,
                          child: const LocationSearchScreen(),
                        ),
                      ),
                    ),
                  ),
                  // 4. Manual
                  _OptionRow(
                    icon: Icons.edit_location_alt_outlined,
                    label: 'Manual Coordinates',
                    sub: 'Offline — enter latitude and longitude directly',
                    rule: rule,
                    ink: ink,
                    inkMute: inkMute,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: cubit,
                          child: const LocationManualScreen(),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        );
      },
    ),
    );
  }
}

class _CurrentLocationCard extends StatelessWidget {
  const _CurrentLocationCard({
    required this.location,
    required this.isResolvingName,
    required this.ink,
    required this.inkMute,
    required this.inkDim,
    required this.rule,
    required this.surfElev,
    required this.accent,
    required this.onClear,
  });

  final UserLocation location;
  final bool isResolvingName;
  final Color ink;
  final Color inkMute;
  final Color inkDim;
  final Color rule;
  final Color surfElev;
  final Color accent;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final lat = location.latitude.toStringAsFixed(4);
    final lon = location.longitude.toStringAsFixed(4);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: surfElev,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: rule),
        ),
        padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
        child: Row(
          children: [
            Icon(Icons.location_on, color: accent, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (isResolvingName) ...[
                        SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(strokeWidth: 1.5, color: inkMute),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Expanded(
                        child: Text(
                          location.label ?? 'Unknown location',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: ink,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text('$lat, $lon', style: TextStyle(fontSize: 12, color: inkMute)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onClear,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(Icons.close, color: inkMute, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.icon,
    required this.label,
    required this.sub,
    required this.rule,
    required this.ink,
    required this.inkMute,
    required this.onTap,
    this.isFirst = false,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final String sub;
  final bool isFirst;
  final Color rule;
  final Color ink;
  final Color inkMute;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: isFirst
            ? null
            : BoxDecoration(border: Border(top: BorderSide(color: rule, width: 1))),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: inkMute, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: ink),
                  ),
                  const SizedBox(height: 2),
                  Text(sub, style: TextStyle(fontSize: 12, color: inkMute)),
                ],
              ),
            ),
            if (trailing != null)
              trailing!
            else
              Icon(
                Directionality.of(context) == TextDirection.rtl
                    ? Icons.chevron_left
                    : Icons.chevron_right,
                color: inkMute,
                size: 18,
              ),
          ],
        ),
      ),
    );
  }
}
