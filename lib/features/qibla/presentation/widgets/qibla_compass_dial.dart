import 'dart:math' show pi, cos, sin;

import 'package:flutter/material.dart';
import 'package:flutter_compass_v2/flutter_compass_v2.dart';
import 'package:awqat/core/theme/cohere_colors.dart';
import 'package:awqat/l10n/app_localizations.dart';

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

    if (!enableCompass) {
      return _StaticView(
        bearing: bearingFromNorth,
        message: l10n.qiblaSensorUnavailable,
      );
    }

    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(
            width: 320,
            height: 320,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final heading = snapshot.data!.heading;
        if (heading == null) {
          return _StaticView(
            bearing: bearingFromNorth,
            message: l10n.qiblaSensorUnavailable,
          );
        }

        final qiblaScreen = (bearingFromNorth - heading + 360) % 360;
        final diff = qiblaScreen <= 180 ? qiblaScreen : 360 - qiblaScreen;
        final aligned = diff < 4;

        return _CompassView(
          heading: heading,
          bearingFromNorth: bearingFromNorth,
          aligned: aligned,
          qiblaScreenAngle: qiblaScreen,
        );
      },
    );
  }
}

class _CompassView extends StatelessWidget {
  const _CompassView({
    required this.heading,
    required this.bearingFromNorth,
    required this.aligned,
    required this.qiblaScreenAngle,
  });

  final double heading;
  final double bearingFromNorth;
  final bool aligned;
  final double qiblaScreenAngle;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final ink = CohereColors.inkColor(brightness);
    final inkMute = CohereColors.inkMute(brightness);
    final accent = CohereColors.accentColor(brightness);

    final directionDeg = qiblaScreenAngle.round();
    final turnRight = qiblaScreenAngle > 0 && qiblaScreenAngle <= 180;
    final turnLabel = aligned
        ? 'ALIGNED'
        : (turnRight ? 'TURN RIGHT' : 'TURN LEFT');

    return SizedBox(
      width: 320,
      height: 320,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Rotating dial
          Transform.rotate(
            angle: -heading * pi / 180,
            child: CustomPaint(
              size: const Size(320, 320),
              painter: _DialPainter(ink: ink, inkMute: inkMute, accent: accent),
            ),
          ),
          // Kaaba marker arm — rotates to qibla bearing on screen
          Transform.rotate(
            angle: (bearingFromNorth - heading) * pi / 180,
            child: CustomPaint(
              size: const Size(320, 320),
              painter: _KaabaArmPainter(aligned: aligned, accent: accent),
            ),
          ),
          // Fixed north pointer at top
          CustomPaint(
            size: const Size(320, 320),
            painter: _NorthArrowPainter(accent: accent),
          ),
          // Center text
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (aligned)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Text(
                    'Facing Qibla',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              else
                Text(
                  '$directionDeg°',
                  style: TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    fontSize: 56,
                    letterSpacing: -1.4,
                    fontWeight: FontWeight.w400,
                    height: 1,
                    color: ink,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              const SizedBox(height: 8),
              Text(
                turnLabel,
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 10,
                  letterSpacing: 0.2,
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

class _DialPainter extends CustomPainter {
  const _DialPainter({
    required this.ink,
    required this.inkMute,
    required this.accent,
  });

  final Color ink;
  final Color inkMute;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final outerR = 154.0;

    final ringPaint = Paint()
      ..color = inkMute.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawCircle(Offset(cx, cy), outerR, ringPaint);

    final tickPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final cardinals = {'N': 0, 'E': 90, 'S': 180, 'W': 270};

    for (var a = 0; a < 360; a += 5) {
      final isCardinal = a % 90 == 0;
      final isMajor = a % 30 == 0;
      final r1 = outerR;
      final r2 = isCardinal
          ? outerR - 14
          : (isMajor ? outerR - 10 : outerR - 6);
      final rad = (a - 90) * pi / 180;
      final start = Offset(cx + r1 * cos(rad), cy + r1 * sin(rad));
      final end = Offset(cx + r2 * cos(rad), cy + r2 * sin(rad));

      tickPaint
        ..color = isCardinal ? ink : inkMute.withValues(alpha: 0.5)
        ..strokeWidth = isCardinal ? 1.5 : 1;
      canvas.drawLine(start, end, tickPaint);
    }

    // Cardinal labels
    final textStyle = TextStyle(
      fontFamily: 'JetBrainsMono',
      fontSize: 11,
      letterSpacing: 0.1,
      color: ink,
      fontWeight: FontWeight.w500,
    );
    for (final entry in cardinals.entries) {
      final rad = (entry.value - 90) * pi / 180;
      final r = outerR - 24.0;
      final x = cx + r * cos(rad);
      final y = cy + r * sin(rad);

      final tp = TextPainter(
        text: TextSpan(text: entry.key, style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, y - tp.height / 2));
    }

    // Degree labels for non-cardinal multiples of 30
    final degStyle = TextStyle(
      fontFamily: 'JetBrainsMono',
      fontSize: 9,
      letterSpacing: 0.05,
      color: inkMute.withValues(alpha: 0.7),
    );
    for (final a in [30, 60, 120, 150, 210, 240, 300, 330]) {
      final rad = (a - 90) * pi / 180;
      final r = outerR - 22.0;
      final x = cx + r * cos(rad);
      final y = cy + r * sin(rad);

      final tp = TextPainter(
        text: TextSpan(text: '$a', style: degStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, y - tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant _DialPainter old) =>
      old.ink != ink || old.inkMute != inkMute;
}

class _KaabaArmPainter extends CustomPainter {
  const _KaabaArmPainter({required this.aligned, required this.accent});
  final bool aligned;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final lineColor = aligned ? accent : accent.withValues(alpha: 0.4);

    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = aligned ? 1.8 : 1
      ..style = PaintingStyle.stroke;
    if (!aligned) {
      linePaint.strokeCap = StrokeCap.round;
    }

    canvas.drawLine(Offset(cx, cy), Offset(cx, cy - 122), linePaint);

    // Kaaba circle
    final circleFill = Paint()
      ..color = aligned ? accent : Colors.transparent
      ..style = PaintingStyle.fill;
    final circleStroke = Paint()
      ..color = aligned ? accent : lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawCircle(Offset(cx, cy - 128), 16, circleFill);
    canvas.drawCircle(Offset(cx, cy - 128), 16, circleStroke);

    // Kaaba glyph (simple square)
    final glyphColor = aligned ? Colors.white : accent;
    final glyphPaint = Paint()
      ..color = glyphColor
      ..style = PaintingStyle.fill;
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, cy - 128), width: 14, height: 10),
      const Radius.circular(1.5),
    );
    canvas.drawRRect(rect, glyphPaint);
    final linePaint2 = Paint()
      ..color = aligned ? accent : Colors.white
      ..strokeWidth = 1.5;
    canvas.drawLine(
      Offset(cx - 7, cy - 128),
      Offset(cx + 7, cy - 128),
      linePaint2,
    );
  }

  @override
  bool shouldRepaint(covariant _KaabaArmPainter old) =>
      old.aligned != aligned || old.accent != accent;
}

class _NorthArrowPainter extends CustomPainter {
  const _NorthArrowPainter({required this.accent});
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final paint = Paint()
      ..color = accent
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(cx, 8)
      ..lineTo(cx - 6, 22)
      ..lineTo(cx + 6, 22)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _NorthArrowPainter old) => old.accent != accent;
}

class _StaticView extends StatelessWidget {
  const _StaticView({required this.bearing, required this.message});
  final double bearing;
  final String message;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final ink = CohereColors.inkColor(brightness);
    final inkDim = CohereColors.inkDim(brightness);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 320,
          height: 320,
          child: Center(
            child: Text(
              '${bearing.toStringAsFixed(1)}°',
              style: TextStyle(
                fontFamily: 'SpaceGrotesk',
                fontSize: 56,
                letterSpacing: -1.4,
                color: ink,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ),
        Text(
          message,
          style: TextStyle(fontSize: 13, color: inkDim, height: 1.5),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
