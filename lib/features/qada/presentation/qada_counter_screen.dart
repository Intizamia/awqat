import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../core/theme/cohere_colors.dart';
import '../data/qada_repository.dart';
import '../domain/qada_data.dart';
import 'qada_cubit.dart';

class QadaCounterScreen extends StatelessWidget {
  const QadaCounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QadaCubit(QadaRepository())..load(),
      child: const _QadaView(),
    );
  }
}

class _QadaView extends StatelessWidget {
  const _QadaView();

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final surfPage = CohereColors.surfPage(brightness);
    final ink = CohereColors.inkColor(brightness);
    final inkDim = CohereColors.inkDim(brightness);
    final inkMute = CohereColors.inkMute(brightness);
    final rule = CohereColors.surfRule(brightness);
    final accent = CohereColors.accentColor(brightness);
    final statusBarHeight = MediaQuery.of(context).viewPadding.top;

    return Scaffold(
      backgroundColor: surfPage,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Sticky header — E-Bare style
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: const Icon(Icons.chevron_left, size: 18),
                      label: const Text(
                        'More',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
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
                        'QAḌĀ',
                        style: cohereMonoLabel(context,
                            fontSize: 11, letterSpacing: 0.14, color: inkDim),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Counter',
                        style:
                            Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontSize: 40,
                          letterSpacing: -0.8,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(height: 1, color: rule),
              ],
            ),
          ),
          // Prayer rows
          Expanded(
            child: BlocBuilder<QadaCubit, QadaData>(
              builder: (context, data) {
                final cubit = context.read<QadaCubit>();
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: QadaPrayer.values.length + 1,
                  itemBuilder: (context, index) {
                    if (index == QadaPrayer.values.length) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                        child: Text(
                          'Tap − when you make one up.  Tap + when you miss.',
                          style: TextStyle(fontSize: 12, color: inkMute),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    final prayer = QadaPrayer.values[index];
                    final entry = data.entryFor(prayer);
                    final isLast = index == QadaPrayer.values.length - 1;
                    return _PrayerRow(
                      entry: entry,
                      isFirst: index == 0,
                      isLast: isLast,
                      ink: ink,
                      inkMute: inkMute,
                      rule: rule,
                      onIncrement: () => cubit.increment(prayer),
                      onDecrement: () => cubit.decrement(prayer),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PrayerRow extends StatelessWidget {
  const _PrayerRow({
    required this.entry,
    required this.isFirst,
    required this.isLast,
    required this.ink,
    required this.inkMute,
    required this.rule,
    required this.onIncrement,
    required this.onDecrement,
  });

  final QadaEntry entry;
  final bool isFirst;
  final bool isLast;
  final Color ink;
  final Color inkMute;
  final Color rule;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  String get _timestamp {
    if (entry.updatedAt == null) return '–';
    final now = DateTime.now();
    final diff = now.difference(entry.updatedAt!);
    if (diff.inSeconds < 60) return 'Updated just now';
    if (diff.inMinutes < 60) return 'Updated ${diff.inMinutes}m ago';
    if (diff.inHours < 24) return 'Updated ${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Updated yesterday';
    return 'Updated ${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final surfPage = CohereColors.surfPage(brightness);
    final textColor = entry.count == 0 ? inkMute : ink;

    return Container(
      decoration: BoxDecoration(
        color: surfPage,
        border: Border(
          top: isFirst ? BorderSide.none : BorderSide(color: rule),
          bottom: isLast ? BorderSide(color: rule) : BorderSide.none,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 18),
      child: Row(
        children: [
          // Left: name + timestamp (E-Bare)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.prayer.label,
                  style: TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    fontSize: 22,
                    letterSpacing: -0.2,
                    color: textColor,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _timestamp,
                  style: TextStyle(
                    fontSize: 12,
                    color: inkMute,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          // Right: − number + (G-Monument)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _CircleButton(
                label: '−',
                onTap: onDecrement,
                rule: rule,
                ink: inkMute,
              ),
              SizedBox(
                width: 72,
                child: Text(
                  '${entry.count}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    fontSize: entry.count >= 10 ? 44 : 56,
                    height: 0.9,
                    letterSpacing: -1.6,
                    fontFeatures: const [FontFeature.tabularFigures()],
                    color: entry.count == 0
                        ? inkMute.withValues(alpha: 0.4)
                        : ink,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              _CircleButton(
                label: '+',
                onTap: onIncrement,
                rule: rule,
                ink: inkMute,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.label,
    required this.onTap,
    required this.rule,
    required this.ink,
  });

  final String label;
  final VoidCallback onTap;
  final Color rule;
  final Color ink;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: rule),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: ink,
              height: 1,
              leadingDistribution: TextLeadingDistribution.even,
            ),
          ),
        ),
      ),
    );
  }
}
