import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:times/core/navigation/primary_scroll_registry.dart';
import 'package:times/core/utils/prayer_time_format.dart';
import 'package:times/features/prayer/presentation/widgets/prayer_date_header.dart';
import 'package:times/features/prayer/domain/prayer_name.dart';
import 'package:times/features/prayer/presentation/prayer_name_l10n.dart';
import 'package:times/features/prayer/presentation/prayer_times_cubit.dart';
import 'package:times/features/prayer/presentation/prayer_times_state.dart';
import 'package:times/features/prayer/presentation/widgets/setup_checklist_body.dart';
import 'package:times/features/settings/presentation/settings_cubit.dart';
import 'package:times/features/settings/presentation/settings_state.dart';
import 'package:times/l10n/app_localizations.dart';

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen>
    with WidgetsBindingObserver {
  static const _branchIndex = 0;

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    PrimaryScrollRegistry.instance.register(_branchIndex, _scrollController);
    WidgetsBinding.instance.addPostFrameCallback((_) => _refresh());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    PrimaryScrollRegistry.instance.unregister(_branchIndex, _scrollController);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refresh();
    }
  }

  void _refresh() {
    final settings = context.read<SettingsCubit>().state;
    if (!settings.isLoading) {
      context.read<PrayerTimesCubit>().refresh(settings.settings);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<SettingsCubit, SettingsState>(
      listenWhen: (prev, curr) =>
          prev.settings != curr.settings && !curr.isLoading,
      listener: (context, state) {
        context.read<PrayerTimesCubit>().refresh(state.settings);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.prayerTimesTitle),
          actions: [
            BlocBuilder<SettingsCubit, SettingsState>(
              buildWhen: (prev, curr) =>
                  prev.settings.setup.isComplete !=
                  curr.settings.setup.isComplete,
              builder: (context, settingsState) {
                if (!settingsState.settings.setup.isComplete) {
                  return const SizedBox.shrink();
                }
                return Semantics(
                  button: true,
                  label: l10n.qiblaTitle,
                  child: IconButton(
                    icon: const Icon(Icons.explore_outlined),
                    tooltip: l10n.qiblaTitle,
                    onPressed: () => context.push('/qibla'),
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, settingsState) {
            if (settingsState.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!settingsState.settings.setup.isComplete) {
              return SetupChecklistBody(settings: settingsState.settings);
            }

            return BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
              builder: (context, prayerState) {
                if (prayerState.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (prayerState.errorMessage != null) {
                  return Center(child: Text(prayerState.errorMessage!));
                }

                final schedule = prayerState.schedule;
                if (schedule == null) {
                  return const SizedBox.shrink();
                }

                final appSettings = settingsState.settings;
                final timeFormat = appSettings.timeFormat;
                final visibleEntries = schedule.entries
                    .where(
                      (e) =>
                          appSettings.showSunrise ||
                          e.name != PrayerName.sunrise,
                    )
                    .toList();
                final next = schedule.nextPrayer!;
                final remaining = next.time.difference(DateTime.now());
                final locationLabel = appSettings.location?.label ?? '';

                return RefreshIndicator(
                  onRefresh: () async => _refresh(),
                  child: ListView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    children: [
                      if (locationLabel.isNotEmpty)
                        Text(
                          locationLabel,
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                        ),
                      PrayerDateHeader(
                        date: schedule.date,
                        localeCode: appSettings.localeCode,
                        hijriAdjustmentDays: appSettings.hijriAdjustmentDays,
                      ),
                      const SizedBox(height: 16),
                      Semantics(
                        container: true,
                        label: l10n.semanticsNextPrayer(
                          next.name.label(l10n),
                          formatPrayerTime(next.time, format: timeFormat),
                        ),
                        child: Card(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.nextPrayer,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                next.name.label(l10n),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${formatPrayerTime(next.time, format: timeFormat)} · ${formatCountdown(remaining.isNegative ? Duration.zero : remaining)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ),
                      const SizedBox(height: 16),
                      ...visibleEntries.map((entry) {
                        final isNext = entry.name == next.name;
                        return Semantics(
                          label: l10n.semanticsPrayerTime(
                            entry.name.label(l10n),
                            formatPrayerTime(entry.time, format: timeFormat),
                          ),
                          child: ListTile(
                          leading: Icon(
                            isNext ? Icons.nightlight_round : Icons.schedule,
                            color: isNext
                                ? Theme.of(context).colorScheme.primary
                                : null,
                          ),
                          title: Text(entry.name.label(l10n)),
                          trailing: Text(
                            formatPrayerTime(entry.time, format: timeFormat),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        );
                      }),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
