import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../core/navigation/primary_scroll_registry.dart';
import '../../../core/theme/cohere_colors.dart';
import '../../../l10n/app_localizations.dart';

const _kDiscoverBranchIndex = 1;

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    PrimaryScrollRegistry.instance.register(
      _kDiscoverBranchIndex,
      _scrollController,
    );
  }

  @override
  void dispose() {
    PrimaryScrollRegistry.instance.unregister(
      _kDiscoverBranchIndex,
      _scrollController,
    );
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final brightness = Theme.of(context).brightness;
    final surfPage = CohereColors.surfPage(brightness);
    final ink = CohereColors.inkColor(brightness);
    final inkDim = CohereColors.inkDim(brightness);
    final inkMute = CohereColors.inkMute(brightness);
    final rule = CohereColors.surfRule(brightness);
    final accent = CohereColors.accentColor(brightness);
    final surfStone = CohereColors.surfStone(brightness);
    final statusBarHeight = MediaQuery.of(context).viewPadding.top;

    return Scaffold(
      backgroundColor: surfPage,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Sticky header
          ColoredBox(
            color: surfPage,
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, statusBarHeight * 2, 24, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.navDiscover.toUpperCase(),
                    style: cohereMonoLabel(
                      context,
                      fontSize: 11,
                      letterSpacing: 0.12,
                      color: inkDim,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'More for your day',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontSize: 40,
                      letterSpacing: -0.8,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Tools to support your worship beyond prayer times.',
                    style: TextStyle(fontSize: 14, color: inkDim, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
          // Scrollable content
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: EdgeInsets.zero,
              children: [
                _FeatureRow(
                  glyph: _QiblaGlyph(accent: accent),
                  glyphBg: accent,
                  title: 'Qibla Direction',
                  description:
                      'Find the direction of the Kaaba from your location.',
                  isLive: true,
                  rule: rule,
                  ink: ink,
                  inkDim: inkDim,
                  inkMute: inkMute,
                  onTap: () => context.push('/qibla'),
                ),
                _FeatureRow(
                  glyph: _QadaGlyph(ink: ink),
                  glyphBg: accent,
                  title: 'Qada Counter',
                  description: 'Track and make up missed prayers.',
                  isLive: true,
                  rule: rule,
                  ink: ink,
                  inkDim: inkDim,
                  inkMute: inkMute,
                  onTap: () => context.push('/qada'),
                ),
                _FeatureRow(
                  glyph: const _DashedCircleGlyph(),
                  glyphBg: surfStone,
                  title: 'Adhkar',
                  description: 'Morning, evening, and after-prayer remembrances.',
                  tag: 'SOON',
                  tagColor: inkMute,
                  isLive: false,
                  rule: rule,
                  ink: ink,
                  inkDim: inkDim,
                  inkMute: inkMute,
                  isLast: true,
                ),
                Container(
                  height: 1,
                  color: rule,
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.glyph,
    required this.glyphBg,
    required this.title,
    required this.description,
    required this.isLive,
    required this.rule,
    required this.ink,
    required this.inkDim,
    required this.inkMute,
    this.tag,
    this.tagColor,
    this.onTap,
    this.isLast = false,
  });

  final Widget glyph;
  final Color glyphBg;
  final String title;
  final String description;
  final String? tag;
  final Color? tagColor;
  final bool isLive;
  final Color rule;
  final Color ink;
  final Color inkDim;
  final Color inkMute;
  final VoidCallback? onTap;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final row = Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: rule, width: 1)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 18),
      child: Opacity(
        opacity: isLive ? 1.0 : 0.55,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(shape: BoxShape.circle, color: glyphBg),
              child: Center(child: glyph),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 22,
                      letterSpacing: -0.2,
                      fontWeight: FontWeight.w400,
                      color: ink,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(fontSize: 13, color: inkDim, height: 1.4),
                  ),
                ],
              ),
            ),
            if (tag != null && tagColor != null) ...[
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: tagColor!, width: 1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  tag!,
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 10,
                    letterSpacing: 0.14,
                    color: tagColor,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );

    if (onTap != null) {
      return InkWell(onTap: onTap, child: row);
    }
    return row;
  }
}

class _QadaGlyph extends StatelessWidget {
  const _QadaGlyph({required this.ink});
  final Color ink;

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.check_circle_outline, size: 22, color: Colors.white);
  }
}

class _QiblaGlyph extends StatelessWidget {
  const _QiblaGlyph({required this.accent});
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(22, 22),
      painter: _QiblaGlyphPainter(color: Colors.white),
    );
  }
}

class _QiblaGlyphPainter extends CustomPainter {
  const _QiblaGlyphPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;

    canvas.drawCircle(Offset(cx, cy), cx - 0.8, paint);

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final needlePath = Path()
      ..moveTo(cx + 3.5, cy - 1.5)
      ..lineTo(cx + 1.5, cy + 3.7)
      ..lineTo(cx - 1.8, cy + 1.8)
      ..lineTo(cx - 3.7, cy - 1.5)
      ..lineTo(cx - 1.5, cy + 1.5)
      ..lineTo(cx + 1.8, cy - 1.8)
      ..close();
    canvas.drawPath(needlePath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DashedCircleGlyph extends StatelessWidget {
  const _DashedCircleGlyph();

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return CustomPaint(
      size: const Size(22, 22),
      painter: _DashedCirclePainter(color: CohereColors.inkMute(brightness)),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  const _DashedCirclePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = cx - 1;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    const dashCount = 12;
    const dashAngle = 2 * 3.14159265 / dashCount;
    const gapFraction = 0.45;
    for (var i = 0; i < dashCount; i++) {
      final startAngle = i * dashAngle;
      final sweepAngle = dashAngle * (1 - gapFraction);
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
