import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/cohere_colors.dart';
import '../../../app/theme.dart';
import 'location_cubit.dart';
import 'location_state.dart';
import '../../settings/presentation/settings_cubit.dart';
import '../../settings/presentation/settings_state.dart';
import '../domain/city_search_result.dart';
import '../../../l10n/app_localizations.dart';

class LocationSearchScreen extends StatefulWidget {
  const LocationSearchScreen({super.key});

  @override
  State<LocationSearchScreen> createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    final trimmed = value.trim();
    if (trimmed.length < 2) {
      context.read<LocationCubit>().clearSearch();
      return;
    }
    context.read<LocationCubit>().beginSearch();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (mounted) context.read<LocationCubit>().searchCities(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final surfPage = CohereColors.surfPage(brightness);
    final ink = CohereColors.inkColor(brightness);
    final inkMute = CohereColors.inkMute(brightness);
    final inkDim = CohereColors.inkDim(brightness);
    final accent = CohereColors.accentColor(brightness);
    final rule = CohereColors.surfRule(brightness);
    final surfElev = CohereColors.surfElevColor(brightness);
    final statusBarHeight = MediaQuery.of(context).viewPadding.top;

    return BlocListener<SettingsCubit, SettingsState>(
      listenWhen: (prev, curr) {
        final p = prev.settings.location;
        final c = curr.settings.location;
        if (c == null) return false;
        if (p == null) return true;
        return p.latitude != c.latitude || p.longitude != c.longitude;
      },
      listener: (context, _) {
        if (Navigator.of(context).canPop()) Navigator.of(context).pop();
      },
      child: Scaffold(
        backgroundColor: surfPage,
        body: BlocBuilder<LocationCubit, LocationState>(
          builder: (context, locationState) {
            final cubit = context.read<LocationCubit>();
            final hasSearch = _controller.text.trim().length >= 2;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Sticky header with search bar
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
                            onPressed: () => Navigator.of(context).maybePop(),
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
                            label: const Text(
                              'Location',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 4, 24, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'LOCATION',
                              style: cohereMonoLabel(context, fontSize: 11, color: inkMute),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Search',
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Search bar in header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: TextField(
                          controller: _controller,
                          autofocus: true,
                          textInputAction: TextInputAction.search,
                          style: TextStyle(fontSize: 15, color: ink),
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.searchCityHint,
                            hintStyle: TextStyle(color: inkMute),
                            prefixIcon: Icon(Icons.search, color: inkMute, size: 20),
                            suffixIcon: _controller.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(Icons.clear, color: inkMute, size: 18),
                                    onPressed: () {
                                      _controller.clear();
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
                          onChanged: (v) {
                            setState(() {});
                            _onChanged(v);
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
                // Scrollable results
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      if (hasSearch) ...[
                        if (locationState.isSearching)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: accent),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  AppLocalizations.of(context)!.locationSearching,
                                  style: TextStyle(fontSize: 14, color: inkMute),
                                ),
                              ],
                            ),
                          )
                        else if (locationState.searchReturnedEmpty)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                            child: Text(
                              AppLocalizations.of(context)!.locationSearchNotFoundMessage(
                                _controller.text.trim(),
                              ),
                              style: TextStyle(fontSize: 14, color: inkMute, height: 1.5),
                            ),
                          )
                        else if (locationState.searchResults.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              children: [
                                for (var i = 0; i < locationState.searchResults.length; i++)
                                  _SearchResultRow(
                                    result: locationState.searchResults[i],
                                    isFirst: i == 0,
                                    ink: ink,
                                    inkMute: inkMute,
                                    inkDim: inkDim,
                                    rule: rule,
                                    onTap: () => cubit.selectSearchResult(
                                      locationState.searchResults[i],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                      ],
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SearchResultRow extends StatelessWidget {
  const _SearchResultRow({
    required this.result,
    required this.isFirst,
    required this.ink,
    required this.inkMute,
    required this.inkDim,
    required this.rule,
    required this.onTap,
  });

  final CitySearchResult result;
  final bool isFirst;
  final Color ink;
  final Color inkMute;
  final Color inkDim;
  final Color rule;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: isFirst
            ? null
            : BoxDecoration(border: Border(top: BorderSide(color: rule, width: 1))),
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Icon(Icons.location_on_outlined, color: inkMute, size: 18),
            const SizedBox(width: 12),
            Expanded(child: Text(result.label, style: TextStyle(fontSize: 15, color: ink))),
            Icon(Icons.add, color: inkMute, size: 16),
          ],
        ),
      ),
    );
  }
}
