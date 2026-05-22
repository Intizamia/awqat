import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:times/app/router.dart';
import 'package:times/features/settings/presentation/initial_setup_dialog.dart';
import 'package:times/features/settings/presentation/settings_cubit.dart';
import 'package:times/features/settings/presentation/settings_state.dart';

/// Shows first-run calculation method dialog when required.
class AppSetupListener extends StatefulWidget {
  const AppSetupListener({required this.child, super.key});

  final Widget child;

  @override
  State<AppSetupListener> createState() => _AppSetupListenerState();
}

class _AppSetupListenerState extends State<AppSetupListener> {
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _maybeShowDialog(context.read<SettingsCubit>().state);
    });
  }

  void _maybeShowDialog(SettingsState state) {
    if (_dialogShown || state.isLoading) return;
    if (state.settings.calculation.isConfigured) return;

    _dialogShown = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navContext = rootNavigatorKey.currentContext;
      if (!mounted || navContext == null) {
        _dialogShown = false;
        return;
      }
      showDialog<void>(
        context: navContext,
        barrierDismissible: false,
        builder: (_) => const InitialSetupDialog(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsCubit, SettingsState>(
      listener: (context, state) => _maybeShowDialog(state),
      child: widget.child,
    );
  }
}
