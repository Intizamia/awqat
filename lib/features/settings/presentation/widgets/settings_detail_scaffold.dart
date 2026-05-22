import 'package:flutter/material.dart';

/// Detail screen shell: [SliverAppBar.medium] + scrollable sliver body.
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
    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverAppBar.medium(
            title: _MediumAppBarTitle(title: title, subtitle: subtitle),
            pinned: true,
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

class _MediumAppBarTitle extends StatelessWidget {
  const _MediumAppBarTitle({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
