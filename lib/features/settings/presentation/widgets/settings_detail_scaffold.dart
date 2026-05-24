import 'package:flutter/material.dart';

/// Detail screen shell: [SliverAppBar.large] + scrollable sliver body.
///
/// Collapsed app bar shows [title] only; [subtitle] appears in the expanded header.
class SettingsDetailScaffold extends StatelessWidget {
  const SettingsDetailScaffold({
    required this.title,
    required this.subtitle,
    required this.slivers,
    super.key,
    this.scrollController,
    this.isLoading = false,
  });

  final String title;
  final String subtitle;
  final List<Widget> slivers;
  final ScrollController? scrollController;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverAppBar.large(
            pinned: true,
            title: Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            flexibleSpace: _SettingsLargeAppBarFlexibleSpace(
              title: title,
              subtitle: subtitle,
            ),
          ),
          if (isLoading)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: CircularProgressIndicator()),
            )
          else
            ...slivers,
        ],
      ),
    );
  }
}

/// Expanded header for [SliverAppBar.large]: title + subtitle fade out on collapse.
///
/// Do not use [FlexibleSpaceBar] here — it keeps painting its title while the
/// pinned toolbar title fades in, which causes overlap.
class _SettingsLargeAppBarFlexibleSpace extends StatelessWidget {
  const _SettingsLargeAppBarFlexibleSpace({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final settings = context
        .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
    if (settings == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final delta = settings.maxExtent - settings.minExtent;
    final t = delta > 0
        ? ((settings.currentExtent - settings.minExtent) / delta)
            .clamp(0.0, 1.0)
        : 0.0;

    return Opacity(
      opacity: t,
      child: Align(
        alignment: AlignmentDirectional.bottomStart,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Wraps a [SettingsGroupedCard] (or similar) as a sliver with standard padding.
class SettingsGroupedCardSliver extends StatelessWidget {
  const SettingsGroupedCardSliver({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.symmetric(vertical: 12),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: padding,
      sliver: SliverToBoxAdapter(child: child),
    );
  }
}
