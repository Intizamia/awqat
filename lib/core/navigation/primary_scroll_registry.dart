import 'package:flutter/material.dart';

/// Registers primary [ScrollController]s per bottom-nav branch for scroll-to-top.
class PrimaryScrollRegistry {
  PrimaryScrollRegistry._();

  static final PrimaryScrollRegistry instance = PrimaryScrollRegistry._();

  final Map<int, ScrollController> _controllers = {};

  void register(int branchIndex, ScrollController controller) {
    _controllers[branchIndex] = controller;
  }

  void unregister(int branchIndex, ScrollController controller) {
    if (_controllers[branchIndex] == controller) {
      _controllers.remove(branchIndex);
    }
  }

  void scrollToTop(int branchIndex) {
    final controller = _controllers[branchIndex];
    if (controller == null || !controller.hasClients) return;
    controller.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}
