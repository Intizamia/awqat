import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/cohere_colors.dart';
import '../../../app/theme.dart';
import '../data/cities_data.dart';
import '../domain/city_entry.dart';
import 'location_cubit.dart';
import '../../settings/presentation/settings_cubit.dart';
import '../../settings/presentation/settings_state.dart';

class LocationCitiesScreen extends StatefulWidget {
  const LocationCitiesScreen({super.key});

  @override
  State<LocationCitiesScreen> createState() => _LocationCitiesScreenState();
}

class _LocationCitiesScreenState extends State<LocationCitiesScreen> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final surfPage = CohereColors.surfPage(brightness);
    final ink = CohereColors.inkColor(brightness);
    final inkMute = CohereColors.inkMute(brightness);
    final accent = CohereColors.accentColor(brightness);
    final rule = CohereColors.surfRule(brightness);
    final surfElev = CohereColors.surfElevColor(brightness);
    final statusBarHeight = MediaQuery.of(context).viewPadding.top;
    final cubit = context.read<LocationCubit>();

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
        body: Column(
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
                    padding: const EdgeInsets.fromLTRB(24, 4, 24, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LOCATION',
                          style: cohereMonoLabel(context, fontSize: 11, color: inkMute),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Cities Directory',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      ],
                    ),
                  ),
                  // Search bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.search,
                      style: TextStyle(fontSize: 15, color: ink),
                      decoration: InputDecoration(
                        hintText: 'Search cities...',
                        hintStyle: TextStyle(color: inkMute),
                        prefixIcon: Icon(Icons.search, color: inkMute, size: 20),
                        suffixIcon: _query.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear, color: inkMute, size: 18),
                                onPressed: () {
                                  _controller.clear();
                                  setState(() => _query = '');
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
                      onChanged: (v) => setState(() => _query = v.trim()),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            // Scrollable city list
            Expanded(
              child: _query.isEmpty
                  ? _GroupedListView(
                      ink: ink,
                      inkMute: inkMute,
                      rule: rule,
                      onSelect: (city) => cubit.selectCity(city),
                    )
                  : _FilteredListView(
                      query: _query,
                      ink: ink,
                      inkMute: inkMute,
                      rule: rule,
                      onSelect: (city) => cubit.selectCity(city),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupedListView extends StatelessWidget {
  const _GroupedListView({
    required this.ink,
    required this.inkMute,
    required this.rule,
    required this.onSelect,
  });

  final Color ink;
  final Color inkMute;
  final Color rule;
  final void Function(CityEntry) onSelect;

  @override
  Widget build(BuildContext context) {
    final Map<String, List<CityEntry>> groups = {};
    for (final city in kAllCities) {
      groups.putIfAbsent(city.country, () => []).add(city);
    }
    final countries = groups.keys.toList()..sort();

    final items = <_ListItem>[];
    for (final country in countries) {
      items.add(_HeaderItem(country));
      final cities = groups[country]!;
      for (var i = 0; i < cities.length; i++) {
        items.add(_CityItem(cities[i], isFirst: i == 0));
      }
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: items.length + 1,
      itemBuilder: (context, index) {
        if (index == items.length) return const SizedBox(height: 100);
        final item = items[index];
        if (item is _HeaderItem) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 6),
            child: Text(
              item.country.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
                color: inkMute,
              ),
            ),
          );
        }
        final ci = item as _CityItem;
        return _CityRow(
          city: ci.city,
          isFirst: ci.isFirst,
          ink: ink,
          inkMute: inkMute,
          rule: rule,
          onTap: () => onSelect(ci.city),
        );
      },
    );
  }
}

class _FilteredListView extends StatelessWidget {
  const _FilteredListView({
    required this.query,
    required this.ink,
    required this.inkMute,
    required this.rule,
    required this.onSelect,
  });

  final String query;
  final Color ink;
  final Color inkMute;
  final Color rule;
  final void Function(CityEntry) onSelect;

  @override
  Widget build(BuildContext context) {
    final q = query.toLowerCase();
    final results = kAllCities
        .where((c) =>
            c.city.toLowerCase().contains(q) ||
            c.country.toLowerCase().contains(q))
        .toList();

    if (results.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
        child: Text(
          'No cities found for "$query".',
          style: TextStyle(fontSize: 14, color: inkMute, height: 1.5),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: results.length + 1,
      itemBuilder: (context, index) {
        if (index == results.length) return const SizedBox(height: 100);
        return _CityRow(
          city: results[index],
          isFirst: index == 0,
          ink: ink,
          inkMute: inkMute,
          rule: rule,
          showCountry: true,
          onTap: () => onSelect(results[index]),
        );
      },
    );
  }
}

class _CityRow extends StatelessWidget {
  const _CityRow({
    required this.city,
    required this.isFirst,
    required this.ink,
    required this.inkMute,
    required this.rule,
    required this.onTap,
    this.showCountry = false,
  });

  final CityEntry city;
  final bool isFirst;
  final Color ink;
  final Color inkMute;
  final Color rule;
  final VoidCallback onTap;
  final bool showCountry;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: isFirst
            ? null
            : BoxDecoration(
                border: Border(top: BorderSide(color: rule, width: 0.5)),
              ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(city.city, style: TextStyle(fontSize: 15, color: ink)),
                  if (showCountry)
                    Text(city.country, style: TextStyle(fontSize: 12, color: inkMute)),
                ],
              ),
            ),
            Icon(Icons.add, color: inkMute, size: 16),
          ],
        ),
      ),
    );
  }
}

sealed class _ListItem {}

final class _HeaderItem extends _ListItem {
  _HeaderItem(this.country);
  final String country;
}

final class _CityItem extends _ListItem {
  _CityItem(this.city, {required this.isFirst});
  final CityEntry city;
  final bool isFirst;
}
