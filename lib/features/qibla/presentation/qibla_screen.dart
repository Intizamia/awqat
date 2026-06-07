import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/theme.dart';
import '../../../core/theme/cohere_colors.dart';
import '../../../core/utils/qibla_bearing.dart';
import '../../../core/utils/sensor_check.dart';
import '../../../core/widgets/cohere_settings_widgets.dart';
import 'widgets/qibla_compass_dial.dart';
import '../../settings/presentation/settings_cubit.dart';
import '../../settings/presentation/settings_state.dart';
import '../../../l10n/app_localizations.dart';

const _kaabaLat = 21.4225;
const _kaabaLon = 39.8262;

double _distanceKm(double lat1, double lon1, double lat2, double lon2) {
  const r = 6371.0;
  final dLat = (lat2 - lat1) * math.pi / 180;
  final dLon = (lon2 - lon1) * math.pi / 180;
  final a =
      math.pow(math.sin(dLat / 2), 2) +
      math.cos(lat1 * math.pi / 180) *
          math.cos(lat2 * math.pi / 180) *
          math.pow(math.sin(dLon / 2), 2);
  return 2 * r * math.asin(math.sqrt(a));
}

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
    final supported = await hasMagnetometer();
    if (!mounted) return;
    setState(() {
      _sensorSupported = supported;
      _checkingSensor = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final brightness = Theme.of(context).brightness;
    final surfPage = CohereColors.surfPage(brightness);

    return Scaffold(
      backgroundColor: surfPage,
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settingsState) {
          if (settingsState.isLoading || _checkingSensor) {
            return const Center(child: CircularProgressIndicator());
          }

          final location = settingsState.settings.location;
          if (location == null) {
            return CohereDetailScaffold(
              title: l10n.qiblaTitle,
              backLabel: l10n.navDiscover,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    l10n.qiblaLocationRequired,
                    style: TextStyle(
                      fontSize: 14,
                      color: CohereColors.inkDim(brightness),
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            );
          }

          final bearing = qiblaBearingFromNorth(
            latitude: location.latitude,
            longitude: location.longitude,
          );
          final distKm = _distanceKm(
            location.latitude,
            location.longitude,
            _kaabaLat,
            _kaabaLon,
          );
          final distMi = distKm * 0.621371;

          return CohereDetailScaffold(
            title: l10n.qiblaTitle,
            backLabel: l10n.navDiscover,
            children: [
              _QiblaMeta(
                locationLabel: location.label ?? l10n.locationUnknown,
                bearing: bearing,
              ),
              const SizedBox(height: 12),
              Center(
                child: QiblaCompassDial(
                  bearingFromNorth: bearing,
                  enableCompass: _sensorSupported ?? false,
                ),
              ),
              const SizedBox(height: 16),
              _QiblaInfoRow(distKm: distKm, distMi: distMi),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 18,
                      color: CohereColors.inkMute(brightness),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.qiblaCalibratedHint,
                        style: TextStyle(
                          fontSize: 13,
                          color: CohereColors.inkDim(brightness),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _QiblaMeta extends StatelessWidget {
  const _QiblaMeta({required this.locationLabel, required this.bearing});

  final String locationLabel;
  final double bearing;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final ink = CohereColors.inkColor(brightness);
    final inkMute = CohereColors.inkMute(brightness);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BEARING FROM',
                  style: cohereMonoLabel(
                    context,
                    fontSize: 10,
                    letterSpacing: 0.14,
                    color: inkMute,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  locationLabel,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 22,
                    letterSpacing: -0.2,
                    fontWeight: FontWeight.w400,
                    height: 1.1,
                    color: ink,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${bearing.toStringAsFixed(1)}°',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: 28,
                  letterSpacing: -0.6,
                  fontWeight: FontWeight.w400,
                  color: ink,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              Text(
                'QIBLA · TRUE N',
                style: cohereMonoLabel(
                  context,
                  fontSize: 10,
                  letterSpacing: 0.16,
                  color: inkMute,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QiblaInfoRow extends StatelessWidget {
  const _QiblaInfoRow({required this.distKm, required this.distMi});
  final double distKm;
  final double distMi;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final ink = CohereColors.inkColor(brightness);
    final inkMute = CohereColors.inkMute(brightness);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _InfoCell(
            value: distKm.round().toString(),
            label: 'KM TO MAKKAH',
            ink: ink,
            inkMute: inkMute,
          ),
          _InfoCell(
            value: distMi.round().toString(),
            label: 'MILES',
            ink: ink,
            inkMute: inkMute,
          ),
        ],
      ),
    );
  }
}

class _InfoCell extends StatelessWidget {
  const _InfoCell({
    required this.value,
    required this.label,
    required this.ink,
    required this.inkMute,
  });

  final String value;
  final String label;
  final Color ink;
  final Color inkMute;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontSize: 22,
            letterSpacing: -0.2,
            color: ink,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: cohereMonoLabel(
            context,
            fontSize: 9,
            letterSpacing: 0.1,
            color: inkMute,
          ),
        ),
      ],
    );
  }
}
