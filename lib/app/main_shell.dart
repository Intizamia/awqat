import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'theme.dart';
import '../core/navigation/primary_scroll_registry.dart';
import '../core/theme/cohere_colors.dart';
import '../l10n/app_localizations.dart';

class MainShell extends StatelessWidget {
  const MainShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) {
    if (index == navigationShell.currentIndex) {
      PrimaryScrollRegistry.instance.scrollToTop(index);
      navigationShell.goBranch(index, initialLocation: true);
      return;
    }
    navigationShell.goBranch(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: _CohereTabBar(
        currentIndex: navigationShell.currentIndex,
        onTap: _onTap,
      ),
    );
  }
}

class _CohereTabBar extends StatelessWidget {
  const _CohereTabBar({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final accent = CohereColors.accentColor(brightness);
    final inkMute = CohereColors.inkMute(brightness);
    final ink = CohereColors.inkColor(brightness);

    final tabs = [
      _TabData(label: l10n.navPrayerTimes, icon: const _ClockIcon(), index: 0),
      _TabData(label: l10n.navDiscover, icon: const _SparkleIcon(), index: 1),
      _TabData(label: l10n.navSettings, icon: const _SettingsIcon(), index: 2),
    ];

    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? CohereColors.tabBgDark : CohereColors.tabBgLight,
            border: Border(
              top: BorderSide(
                color: isDark
                    ? CohereColors.tabBorderDark
                    : CohereColors.tabBorderLight,
                width: 0.5,
              ),
            ),
          ),
          padding: EdgeInsets.only(
            left: 12,
            right: 12,
            top: 8,
            bottom: bottomPadding > 0 ? bottomPadding : 16,
          ),
          child: Row(
            children: tabs.map((tab) {
              final isActive = tab.index == currentIndex;
              return Expanded(
                child: _TabItem(
                  data: tab,
                  isActive: isActive,
                  accent: accent,
                  inkMute: inkMute,
                  ink: ink,
                  onTap: () => onTap(tab.index),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _TabData {
  const _TabData({
    required this.label,
    required this.icon,
    required this.index,
  });
  final String label;
  final Widget icon;
  final int index;
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.data,
    required this.isActive,
    required this.accent,
    required this.inkMute,
    required this.ink,
    required this.onTap,
  });

  final _TabData data;
  final bool isActive;
  final Color accent;
  final Color inkMute;
  final Color ink;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconTheme(
              data: IconThemeData(color: isActive ? accent : inkMute, size: 22),
              child: data.icon,
            ),
            const SizedBox(height: 4),
            Text(
              data.label,
              style: cohereMonoLabel(
                context,
                fontSize: 10,
                letterSpacing: 0.06,
                color: isActive ? ink : inkMute,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Tab icons ─────────────────────────────────────────────────────────────

class _ClockIcon extends StatelessWidget {
  const _ClockIcon();

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.access_time_outlined, size: 22);
  }
}

class _SparkleIcon extends StatelessWidget {
  const _SparkleIcon();

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.auto_awesome_outlined, size: 22);
  }
}

class _SettingsIcon extends StatelessWidget {
  const _SettingsIcon();

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.settings_outlined, size: 22);
  }
}
