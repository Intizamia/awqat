import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/theme.dart';
import '../../../../core/theme/cohere_colors.dart';
import '../../../settings/presentation/settings_cubit.dart';
import '../../domain/prayer_name.dart';
import '../../domain/prayer_notif_type.dart';

class PrayerNotifDisc extends StatelessWidget {
  const PrayerNotifDisc({
    required this.name,
    required this.notifType,
    super.key,
  });

  final PrayerName name;
  final PrayerNotifType notifType;

  static List<PrayerNotifType> _availableTypes(
    PrayerName name,
    TargetPlatform platform,
  ) {
    final isIos = platform == TargetPlatform.iOS;
    final isSunrise = name == PrayerName.sunrise;
    if (isIos && isSunrise) {
      return const [PrayerNotifType.none];
    }
    if (isIos) {
      return const [PrayerNotifType.none, PrayerNotifType.takbir];
    }
    if (isSunrise) {
      return const [PrayerNotifType.none, PrayerNotifType.reminder];
    }
    return PrayerNotifType.values;
  }

  void _showMenu(BuildContext ctx) {
    final box = ctx.findRenderObject() as RenderBox;
    final pos = box.localToGlobal(Offset.zero);
    final size = box.size;
    final screenWidth = MediaQuery.of(ctx).size.width;
    final brightness = Theme.of(ctx).brightness;
    final ink = CohereColors.inkColor(brightness);
    final inkMute = CohereColors.inkMute(brightness);
    final menuBg = CohereColors.surfElevColor(brightness);
    final menuBorder = CohereColors.surfRule(brightness);
    final accent = CohereColors.accentColor(brightness);

    final position = RelativeRect.fromLTRB(
      pos.dx,
      pos.dy + size.height + 4,
      screenWidth - pos.dx - size.width,
      0,
    );

    final cubit = ctx.read<SettingsCubit>();

    final availableTypes = _availableTypes(
      name,
      Theme.of(ctx).platform,
    );

    showMenu<PrayerNotifType>(
      context: ctx,
      position: position,
      color: menuBg,
      elevation: 8,
      shadowColor: Colors.black38,
      menuPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: menuBorder),
      ),
      items: [
        PopupMenuItem<PrayerNotifType>(
          enabled: false,
          height: 36,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Text(
            'NOTIFICATION',
            style: cohereMonoLabel(
              ctx,
              fontSize: 10,
              letterSpacing: 0.18,
              color: inkMute,
            ),
          ),
        ),
        for (final type in availableTypes)
          PopupMenuItem<PrayerNotifType>(
            value: type,
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CustomPaint(
                    painter: PrayerNotifIconPainter(
                      type: type,
                      color: type == notifType ? accent : ink,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  type.label,
                  style: TextStyle(
                    fontSize: 15,
                    color: type == notifType ? accent : ink,
                    fontWeight: type == notifType
                        ? FontWeight.w500
                        : FontWeight.w400,
                  ),
                ),
                if (type == notifType) ...[
                  const Spacer(),
                  Icon(Icons.check, size: 16, color: accent),
                ],
              ],
            ),
          ),
      ],
    ).then((selected) {
      if (selected != null && selected != notifType) {
        cubit.setPrayerNotifType(name, selected);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final inkMute = CohereColors.inkMute(brightness);
    final accent = CohereColors.accentColor(brightness);
    final rule = CohereColors.surfRule(brightness);

    final isInactive = notifType == PrayerNotifType.none;

    return Builder(
      builder: (iconCtx) => GestureDetector(
        onTap: () => _showMenu(iconCtx),
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: 36,
          height: 36,
          child: isInactive
              ? CustomPaint(
                  painter: PrayerDashedCirclePainter(color: rule),
                  child: Center(
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CustomPaint(
                        painter: PrayerNotifIconPainter(
                          type: notifType,
                          color: inkMute,
                        ),
                      ),
                    ),
                  ),
                )
              : DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accent,
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CustomPaint(
                        painter: PrayerNotifIconPainter(
                          type: notifType,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class PrayerDashedCirclePainter extends CustomPainter {
  const PrayerDashedCirclePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.25
      ..strokeCap = StrokeCap.butt;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 1;
    final circle = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));

    const dashLen = 3.5;
    const gapLen = 3.0;
    final dashPath = Path();
    for (final metric in circle.computeMetrics()) {
      var dist = 0.0;
      var drawing = true;
      while (dist < metric.length) {
        final seg = drawing ? dashLen : gapLen;
        if (drawing) {
          dashPath.addPath(metric.extractPath(dist, dist + seg), Offset.zero);
        }
        dist += seg;
        drawing = !drawing;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant PrayerDashedCirclePainter old) =>
      old.color != color;
}

class PrayerNotifIconPainter extends CustomPainter {
  const PrayerNotifIconPainter({required this.type, required this.color});

  final PrayerNotifType type;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 24;
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    switch (type) {
      case PrayerNotifType.none:
        _paintNone(canvas, p, s);
      case PrayerNotifType.reminder:
        _paintBell(canvas, p, s);
      case PrayerNotifType.takbir:
        _paintMic(canvas, p, s);
      case PrayerNotifType.fullAthan:
        _paintSpeaker(canvas, p, s);
    }
  }

  void _paintNone(Canvas canvas, Paint p, double s) {
    canvas.drawLine(Offset(7 * s, 12 * s), Offset(17 * s, 12 * s), p);
  }

  void _paintBell(Canvas canvas, Paint p, double s) {
    canvas.drawPath(
      Path()
        ..moveTo(6 * s, 8 * s)
        ..arcToPoint(
          Offset(18 * s, 8 * s),
          radius: Radius.circular(6 * s),
          clockwise: true,
        )
        ..lineTo(18 * s, 11 * s)
        ..lineTo(19.5 * s, 14 * s)
        ..lineTo(4.5 * s, 14 * s)
        ..lineTo(6 * s, 11 * s)
        ..close(),
      p,
    );
    canvas.drawPath(
      Path()
        ..moveTo(10 * s, 18 * s)
        ..arcToPoint(
          Offset(14 * s, 18 * s),
          radius: Radius.circular(2 * s),
          clockwise: false,
        ),
      p,
    );
  }

  void _paintMic(Canvas canvas, Paint p, double s) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(9 * s, 3 * s, 6 * s, 12 * s),
        Radius.circular(3 * s),
      ),
      p,
    );
    canvas.drawPath(
      Path()
        ..moveTo(5 * s, 11 * s)
        ..arcToPoint(
          Offset(19 * s, 11 * s),
          radius: Radius.circular(7 * s),
          clockwise: false,
        ),
      p,
    );
    canvas.drawLine(Offset(12 * s, 18 * s), Offset(12 * s, 21 * s), p);
    canvas.drawLine(Offset(9 * s, 21 * s), Offset(15 * s, 21 * s), p);
  }

  void _paintSpeaker(Canvas canvas, Paint p, double s) {
    canvas.drawPath(
      Path()
        ..moveTo(4 * s, 9 * s)
        ..lineTo(4 * s, 15 * s)
        ..lineTo(8 * s, 15 * s)
        ..lineTo(13 * s, 19 * s)
        ..lineTo(13 * s, 5 * s)
        ..lineTo(8 * s, 9 * s)
        ..close(),
      p,
    );
    canvas.drawPath(
      Path()
        ..moveTo(16 * s, 8.5 * s)
        ..arcToPoint(
          Offset(16 * s, 15.5 * s),
          radius: Radius.circular(5 * s),
          clockwise: true,
        ),
      p,
    );
    canvas.drawPath(
      Path()
        ..moveTo(19 * s, 5.5 * s)
        ..arcToPoint(
          Offset(19 * s, 18.5 * s),
          radius: Radius.circular(9 * s),
          clockwise: true,
        ),
      p,
    );
  }

  @override
  bool shouldRepaint(covariant PrayerNotifIconPainter old) =>
      old.type != type || old.color != color;
}
