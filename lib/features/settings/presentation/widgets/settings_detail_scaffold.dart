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
    final colorScheme = theme.colorScheme;

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
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              expandedTitleScale: 1,
              titlePadding: const EdgeInsetsDirectional.only(
                start: 16,
                bottom: 16,
              ),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w600,
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

/// Wraps a [SettingsGroupedCard] (or similar) as a sliver with standard padding.
class SettingsGroupedCardSliver extends StatelessWidget {
  const SettingsGroupedCardSliver({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
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
