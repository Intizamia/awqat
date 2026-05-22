import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:times/core/utils/qibla_bearing.dart';
import 'package:times/features/qibla/presentation/widgets/qibla_compass_dial.dart';
import 'package:times/features/settings/presentation/settings_cubit.dart';
import 'package:times/features/settings/presentation/settings_state.dart';
import 'package:times/l10n/app_localizations.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  bool? _sensorSupported;
  bool _checkingSensor = true;

  @override
  void initState() {
    super.initState();
    _checkSensor();
  }

  Future<void> _checkSensor() async {
    final supported = await FlutterQiblah.androidDeviceSensorSupport();
    if (!mounted) return;
    setState(() {
      _sensorSupported = Platform.isIOS ? true : (supported ?? false);
      _checkingSensor = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.qiblaTitle)),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settingsState) {
          if (settingsState.isLoading || _checkingSensor) {
            return const Center(child: CircularProgressIndicator());
          }

          final location = settingsState.settings.location;
          if (location == null) {
            return _MessageBody(
              icon: Icons.location_off_outlined,
              message: l10n.qiblaLocationRequired,
            );
          }

          final bearing = qiblaBearingFromNorth(
            latitude: location.latitude,
            longitude: location.longitude,
          );

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              if (location.label != null && location.label!.isNotEmpty)
                Text(
                  location.label!,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              if (location.label != null && location.label!.isNotEmpty)
                const SizedBox(height: 8),
              Text(
                l10n.qiblaDirectionToKaaba,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              QiblaCompassDial(
                bearingFromNorth: bearing,
                enableCompass: _sensorSupported ?? false,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MessageBody extends StatelessWidget {
  const _MessageBody({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 24),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
