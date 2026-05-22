import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:times/core/utils/prayer_time_format.dart';
import 'package:times/features/prayer/presentation/prayer_name_l10n.dart';
import 'package:times/features/prayer/presentation/prayer_times_cubit.dart';
import 'package:times/features/prayer/presentation/prayer_times_state.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _refresh());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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
        appBar: AppBar(title: Text(l10n.prayerTimesTitle)),
        body: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, settingsState) {
            if (settingsState.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!settingsState.settings.setup.isComplete) {
              return _SetupRequiredBody(l10n: l10n);
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

                final next = schedule.nextPrayer!;
                final remaining = next.time.difference(DateTime.now());
                final locationLabel =
                    settingsState.settings.location?.label ?? '';

                return RefreshIndicator(
                  onRefresh: () async => _refresh(),
                  child: ListView(
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
                      Text(
                        DateFormat.yMMMEd().format(schedule.date),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      Card(
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
                                '${formatPrayerTime(next.time)} · ${formatCountdown(remaining.isNegative ? Duration.zero : remaining)}',
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
                      const SizedBox(height: 16),
                      ...schedule.entries.map((entry) {
                        final isNext = entry.name == next.name;
                        return ListTile(
                          leading: Icon(
                            isNext ? Icons.nightlight_round : Icons.schedule,
                            color: isNext
                                ? Theme.of(context).colorScheme.primary
                                : null,
                          ),
                          title: Text(entry.name.label(l10n)),
                          trailing: Text(
                            formatPrayerTime(entry.time),
                            style: Theme.of(context).textTheme.titleMedium,
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

class _SetupRequiredBody extends StatelessWidget {
  const _SetupRequiredBody({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.settings_suggest_outlined,
            size: 64,
            color: colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.setupRequiredTitle,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.setupRequiredMessage,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: () => context.go('/settings'),
            icon: const Icon(Icons.arrow_forward),
            label: Text(l10n.setup),
          ),
        ],
      ),
    );
  }
}
