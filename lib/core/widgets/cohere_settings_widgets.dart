import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:awqat/app/theme.dart';
import 'package:awqat/core/theme/cohere_colors.dart';

// ─── Section label ──────────────────────────────────────────────────────────

class CohereSectionLabel extends StatelessWidget {
  const CohereSectionLabel({required this.label, super.key});
  final String label;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 8),
      child: Text(
        label.toUpperCase(),
        style: cohereMonoLabel(
          context,
          fontSize: 11,
          letterSpacing: 0.14,
          color: CohereColors.inkMute(brightness),
        ),
      ),
    );
  }
}

// ─── Nav row (label + value + chevron) ──────────────────────────────────────

class CohereNavRow extends StatelessWidget {
  const CohereNavRow({
    required this.label,
    required this.onTap,
    super.key,
    this.sub,
    this.value,
  });

  final String label;
  final String? sub;
  final String? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final rule = CohereColors.surfRule(brightness);
    final ink = CohereColors.inkColor(brightness);
    final inkDim = CohereColors.inkDim(brightness);
    final inkMute = CohereColors.inkMute(brightness);

    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: rule, width: 1)),
        ),
        constraints: const BoxConstraints(minHeight: 56),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      color: ink,
                      fontFamily: 'Inter',
                    ),
                  ),
                  if (sub != null) ...[
                    const SizedBox(height: 2),
                    Text(sub!, style: TextStyle(fontSize: 12, color: inkMute)),
                  ],
                ],
              ),
            ),
            if (value != null) ...[
              const SizedBox(width: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 120),
                child: Text(
                  value!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, color: inkDim),
                ),
              ),
              const SizedBox(width: 6),
            ],
            Icon(
              Directionality.of(context) == TextDirection.rtl
                  ? Icons.chevron_left
                  : Icons.chevron_right,
              size: 16,
              color: inkMute,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Toggle row ─────────────────────────────────────────────────────────────

class CohereToggleRow extends StatelessWidget {
  const CohereToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
    this.sub,
    this.isFirst = false,
  });

  final String label;
  final String? sub;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final rule = CohereColors.surfRule(brightness);
    final ink = CohereColors.inkColor(brightness);
    final inkMute = CohereColors.inkMute(brightness);

    return Container(
      decoration: isFirst
          ? null
          : BoxDecoration(
              border: Border(top: BorderSide(color: rule, width: 1)),
            ),
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label, style: TextStyle(fontSize: 15, color: ink)),
                if (sub != null) ...[
                  const SizedBox(height: 2),
                  Text(sub!, style: TextStyle(fontSize: 12, color: inkMute)),
                ],
              ],
            ),
          ),
          _CohereToggle(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _CohereToggle extends StatelessWidget {
  const _CohereToggle({required this.value, required this.onChanged});
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final accent = CohereColors.accentColor(brightness);
    final rule = CohereColors.surfRule(brightness);

    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 51,
        height: 31,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(31),
          color: value ? accent : rule,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Container(
              width: 27,
              height: 27,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Radio group ─────────────────────────────────────────────────────────────

class CohereRadioGroup<T> extends StatelessWidget {
  const CohereRadioGroup({
    required this.value,
    required this.options,
    required this.onChanged,
    super.key,
  });

  final T value;
  final List<CohereRadioOption<T>> options;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: Row(
        children: options.map((opt) {
          final isSelected = opt.value == value;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: opt == options.last ? 0 : 6),
              child: _RadioPill(
                label: opt.label,
                isSelected: isSelected,
                onTap: () => onChanged(opt.value),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class CohereRadioOption<T> {
  const CohereRadioOption({required this.value, required this.label});
  final T value;
  final String label;
}

class _RadioPill extends StatelessWidget {
  const _RadioPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final ink = CohereColors.inkColor(brightness);
    final rule = CohereColors.surfRule(brightness);
    final inkDim = CohereColors.inkDim(brightness);
    final surfPage = CohereColors.surfPage(brightness);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? ink : Colors.transparent,
          border: Border.all(color: isSelected ? ink : rule),
          borderRadius: BorderRadius.circular(32),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isSelected ? surfPage : inkDim,
          ),
        ),
      ),
    );
  }
}

// ─── Stepper row ─────────────────────────────────────────────────────────────

class CohereStepperRow extends StatelessWidget {
  const CohereStepperRow({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
    this.sub,
    this.min = -30,
    this.max = 30,
    this.unit = 'min',
    this.isFirst = false,
  });

  final String label;
  final String? sub;
  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  final String unit;
  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final rule = CohereColors.surfRule(brightness);
    final ink = CohereColors.inkColor(brightness);
    final inkMute = CohereColors.inkMute(brightness);
    final surfPage = CohereColors.surfPage(brightness);
    final surfElev = CohereColors.surfElevColor(brightness);

    return Container(
      decoration: isFirst
          ? null
          : BoxDecoration(
              border: Border(top: BorderSide(color: rule, width: 1)),
            ),
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label, style: TextStyle(fontSize: 15, color: ink)),
                if (sub != null) ...[
                  const SizedBox(height: 2),
                  Text(sub!, style: TextStyle(fontSize: 12, color: inkMute)),
                ],
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: rule),
              borderRadius: BorderRadius.circular(32),
              color: surfPage,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _StepButton(
                  label: '−',
                  onTap: value > min ? () => onChanged(value - 1) : null,
                  surfElev: surfElev,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Text(
                    '${value > 0 ? '+' : ''}$value${unit.isNotEmpty ? ' $unit' : ''}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: ink,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
                _StepButton(
                  label: '+',
                  onTap: value < max ? () => onChanged(value + 1) : null,
                  surfElev: surfElev,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.label,
    required this.onTap,
    required this.surfElev,
  });
  final String label;
  final VoidCallback? onTap;
  final Color surfElev;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 18,
              color: onTap != null
                  ? Theme.of(context).colorScheme.onSurface
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Method selection row ────────────────────────────────────────────────────

class CohereMethodRow extends StatelessWidget {
  const CohereMethodRow({
    required this.title,
    required this.isSelected,
    super.key,
    this.onTap,
    this.sub,
    this.isFirst = false,
  });

  final String title;
  final String? sub;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final rule = CohereColors.surfRule(brightness);
    final ink = CohereColors.inkColor(brightness);
    final inkMute = CohereColors.inkMute(brightness);
    final accent = CohereColors.accentColor(brightness);

    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: isFirst
            ? null
            : BoxDecoration(
                border: Border(top: BorderSide(color: rule, width: 1)),
              ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: ink,
                    ),
                  ),
                  if (sub != null) ...[
                    const SizedBox(height: 3),
                    Text(sub!, style: TextStyle(fontSize: 12, color: inkMute)),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? accent : Colors.transparent,
                border: Border.all(
                  color: isSelected ? accent : rule,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Sub-page scaffold ───────────────────────────────────────────────────────

class CohereDetailScaffold extends StatelessWidget {
  const CohereDetailScaffold({
    required this.title,
    required this.children,
    super.key,
    this.backLabel = 'Settings',
    this.intro,
  });

  final String title;
  final String backLabel;
  final String? intro;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final surfPage = CohereColors.surfPage(brightness);
    final accent = CohereColors.accentColor(brightness);
    final inkMute = CohereColors.inkMute(brightness);
    final inkDim = CohereColors.inkDim(brightness);
    final statusBarHeight = MediaQuery.of(context).viewPadding.top;

    return Scaffold(
      backgroundColor: surfPage,
      body: ListView(
        children: [
          SizedBox(height: statusBarHeight + 8),
          // Back button
          Row(
            children: [
              const SizedBox(width: 4),
              TextButton.icon(
                onPressed: () => context.pop(),
                style: TextButton.styleFrom(
                  foregroundColor: accent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: Icon(
                  Directionality.of(context) == TextDirection.rtl
                      ? Icons.chevron_right
                      : Icons.chevron_left,
                  size: 18,
                ),
                label: Text(
                  backLabel,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          // Title block
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 4, 24, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  backLabel,
                  style: cohereMonoLabel(context, fontSize: 11, color: inkMute),
                ),
                const SizedBox(height: 4),
                Text(title, style: Theme.of(context).textTheme.displaySmall),
                if (intro != null) ...[
                  const SizedBox(height: 14),
                  Text(
                    intro!,
                    style: TextStyle(fontSize: 13, color: inkDim, height: 1.5),
                  ),
                ],
              ],
            ),
          ),
          ...children,
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
