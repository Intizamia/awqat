import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../core/theme/cohere_colors.dart';
import '../domain/adhkar_data.dart';

class AdhkarScreen extends StatelessWidget {
  const AdhkarScreen({super.key});

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
                        'AFTER PRAYER',
                        style: cohereMonoLabel(context,
                            fontSize: 11, letterSpacing: 0.14, color: inkDim),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Adhkār',
                        style:
                            Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontFamily: 'SpaceGrotesk',
                          fontSize: 40,
                          letterSpacing: -0.8,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Six supplications recited after each obligatory prayer.',
                        style: TextStyle(
                            fontSize: 14, color: inkDim, height: 1.55),
                      ),
                    ],
                  ),
                ),
                Container(height: 1, color: rule),
              ],
            ),
          ),
          // Scrollable list
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: afterPrayerAdhkar.length + 1,
              itemBuilder: (context, index) {
                if (index == afterPrayerAdhkar.length) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                    child: Text(
                      'END · SIX',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 10,
                        letterSpacing: 0.18 * 10,
                        color: inkMute,
                      ),
                    ),
                  );
                }
                final dhikr = afterPrayerAdhkar[index];
                final isFirst = index == 0;
                return _DhikrItem(
                  dhikr: dhikr,
                  index: index,
                  isFirst: isFirst,
                  ink: ink,
                  inkMute: inkMute,
                  rule: rule,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DhikrItem extends StatelessWidget {
  const _DhikrItem({
    required this.dhikr,
    required this.index,
    required this.isFirst,
    required this.ink,
    required this.inkMute,
    required this.rule,
  });

  final Dhikr dhikr;
  final int index;
  final bool isFirst;
  final Color ink;
  final Color inkMute;
  final Color rule;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: isFirst ? BorderSide.none : BorderSide(color: rule),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                (index + 1).toString().padLeft(2, '0'),
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 11,
                  letterSpacing: 0.14 * 11,
                  color: inkMute,
                ),
              ),
              Text(
                '× ${dhikr.count}',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 11,
                  letterSpacing: 0.14 * 11,
                  color: inkMute,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              dhikr.arabic,
              style: TextStyle(
                fontSize: 30,
                height: 1.55,
                color: ink,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            dhikr.transliteration,
            style: TextStyle(
              fontSize: 13,
              fontStyle: FontStyle.italic,
              color: inkMute,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            dhikr.english,
            style: TextStyle(
              fontSize: 14,
              color: ink,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}
