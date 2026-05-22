import 'package:flutter/material.dart';

/// Ensures tappable controls meet Material minimum touch target (48dp).
class MinimumTapTarget extends StatelessWidget {
  const MinimumTapTarget({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: kMinInteractiveDimension,
        minHeight: kMinInteractiveDimension,
      ),
      child: Center(child: child),
    );
  }
}
