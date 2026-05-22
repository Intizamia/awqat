import 'dart:math' show cos, pi, sin;

import 'package:flutter/material.dart';
import 'package:flutter_compass_v2/flutter_compass_v2.dart';
import 'package:times/core/utils/qibla_bearing.dart';
import 'package:times/l10n/app_localizations.dart';

/// Live compass dial using device heading and a fixed Qibla bearing.
class QiblaCompassDial extends StatelessWidget {
  const QiblaCompassDial({
    required this.bearingFromNorth,
    this.enableCompass = true,
    super.key,
  });

  final double bearingFromNorth;
  final bool enableCompass;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final stream = enableCompass ? FlutterCompass.events : null;

    if (stream == null) {
      return _StaticBearingCard(
        bearingFromNorth: bearingFromNorth,
        message: l10n.qiblaSensorUnavailable,
      );
    }

    return StreamBuilder<CompassEvent>(
      stream: stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final heading = snapshot.data!.heading;
        if (heading == null) {
          return _StaticBearingCard(
            bearingFromNorth: bearingFromNorth,
            message: l10n.qiblaSensorUnavailable,
          );
        }

        final pointer = qiblaPointerDegrees(
          deviceHeading: heading,
          bearingFromNorth: bearingFromNorth,
        );
        final aligned = _isAligned(heading, bearingFromNorth);

        return Column(
          children: [
            SizedBox(
              width: 280,
              height: 280,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Transform.rotate(
                    angle: -heading * pi / 180,
                    child: _CompassRose(colorScheme: Theme.of(context).colorScheme),
                  ),
                  Transform.rotate(
                    angle: -pointer * pi / 180,
                    child: _QiblaNeedle(colorScheme: Theme.of(context).colorScheme),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.qiblaBearingDegrees(bearingFromNorth.toStringAsFixed(1)),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              aligned ? l10n.qiblaAligned : l10n.qiblaCalibratedHint,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: aligned
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );
  }

  bool _isAligned(double heading, double bearing) {
    final diff = (heading - bearing).abs() % 360;
    return diff < 5 || diff > 355;
  }
}

class _CompassRose extends StatelessWidget {
  const _CompassRose({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CompassRosePainter(colorScheme: colorScheme),
      size: const Size(280, 280),
    );
  }
}

class _CompassRosePainter extends CustomPainter {
  _CompassRosePainter({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;

    final ring = Paint()
      ..color = colorScheme.outlineVariant
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, ring);

    final tick = Paint()
      ..color = colorScheme.onSurfaceVariant
      ..strokeWidth = 2;
    for (var i = 0; i < 36; i++) {
      final angle = i * 10 * pi / 180;
      final inner = i % 9 == 0 ? radius - 16 : radius - 8;
      final outer = radius;
      final start = Offset(
        center.dx + inner * sin(angle),
        center.dy - inner * cos(angle),
      );
      final end = Offset(
        center.dx + outer * sin(angle),
        center.dy - outer * cos(angle),
      );
      canvas.drawLine(start, end, tick);
    }

    final north = TextPainter(
      text: TextSpan(
        text: 'N',
        style: TextStyle(
          color: colorScheme.primary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    north.paint(
      canvas,
      Offset(center.dx - north.width / 2, center.dy - radius + 4),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _QiblaNeedle extends StatelessWidget {
  const _QiblaNeedle({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.navigation,
      size: 120,
      color: colorScheme.primary,
    );
  }
}

class _StaticBearingCard extends StatelessWidget {
  const _StaticBearingCard({
    required this.bearingFromNorth,
    required this.message,
  });

  final double bearingFromNorth;
  final String message;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.explore_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.qiblaBearingDegrees(bearingFromNorth.toStringAsFixed(1)),
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
