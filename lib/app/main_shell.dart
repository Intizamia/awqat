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
    return PopScope(
      canPop: navigationShell.currentIndex == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _onTap(0);
      },
      child: Scaffold(
        extendBody: true,
        body: navigationShell,
        bottomNavigationBar: _CohereTabBar(
          currentIndex: navigationShell.currentIndex,
          onTap: _onTap,
        ),
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
      _TabData(
        label: l10n.navPrayerTimes,
        iconBuilder: (active) => Icon(
          active ? Icons.access_time : Icons.access_time_outlined,
          size: 22,
        ),
        index: 0,
      ),
      _TabData(
        label: l10n.navDiscover,
        iconBuilder: (active) => Icon(
          active ? Icons.grid_view_rounded : Icons.grid_view_outlined,
          size: 22,
        ),
        index: 1,
      ),
      _TabData(
        label: l10n.navSettings,
        iconBuilder: (active) => Icon(
          active ? Icons.settings : Icons.settings_outlined,
          size: 22,
        ),
        index: 2,
      ),
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
            top: 14,
            bottom: bottomPadding > 0 ? bottomPadding + 6 : 16 + 6,
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
    required this.iconBuilder,
    required this.index,
  });
  final String label;
  final Widget Function(bool isActive) iconBuilder;
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
              child: data.iconBuilder(isActive),
            ),
            const SizedBox(height: 6),
            Text(
              data.label.toUpperCase(),
              style: cohereMonoLabel(
                context,
                fontSize: 12,
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

