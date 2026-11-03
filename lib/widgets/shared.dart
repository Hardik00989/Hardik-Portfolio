import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class RevealOnScroll extends StatefulWidget {
  final Widget child;
  final int delay;
  final VoidCallback? onReveal;
  const RevealOnScroll({
    super.key,
    required this.child,
    this.delay = 0,
    this.onReveal,
  });
  @override
  State<RevealOnScroll> createState() => _RevealOnScrollState();
}

class _RevealOnScrollState extends State<RevealOnScroll> {
  bool visible = false;
  bool scheduled = false;
  @override
  Widget build(BuildContext context) => VisibilityDetector(
    key: ObjectKey(this),
    onVisibilityChanged: (info) async {
      if (info.visibleFraction > .05 && !scheduled) {
        scheduled = true;
        await Future<void>.delayed(Duration(milliseconds: widget.delay));
        if (mounted) {
          setState(() => visible = true);
          widget.onReveal?.call();
        }
      }
    },
    child: AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: Duration(
        milliseconds: MediaQuery.disableAnimationsOf(context) ? 0 : 650,
      ),
      child: AnimatedSlide(
        offset: visible ? Offset.zero : const Offset(0, .035),
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    ),
  );
}

class SectionTitle extends StatelessWidget {
  final String number, label, title;
  const SectionTitle({
    super.key,
    required this.number,
    required this.label,
    required this.title,
  });
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        '$number / $label',
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 11,
          letterSpacing: 1.3,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 22),
      Text(
        title,
        style: TextStyle(
          fontSize: MediaQuery.sizeOf(context).width < 600 ? 36 : 52,
          height: 1.1,
          letterSpacing: -1.6,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}

class HoverSurface extends StatefulWidget {
  final Widget child;
  final bool tilt;
  const HoverSurface({super.key, required this.child, this.tilt = false});
  @override
  State<HoverSurface> createState() => _HoverSurfaceState();
}

class _HoverSurfaceState extends State<HoverSurface> {
  bool hover = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => hover = true),
    onExit: (_) => setState(() => hover = false),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      transform: Matrix4.identity()
        ..translateByDouble(
          0,
          hover && !MediaQuery.disableAnimationsOf(context) ? -3 : 0,
          0,
          1,
        )
        ..rotateZ(
          hover && widget.tilt && !MediaQuery.disableAnimationsOf(context)
              ? -.01
              : 0,
        ),
      child: widget.child,
    ),
  );
}

class AnimatedButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final bool filled;
  final IconData icon;
  final EdgeInsetsGeometry padding;
  const AnimatedButton({
    super.key,
    required this.label,
    required this.onTap,
    this.filled = true,
    this.icon = Icons.north_east,
    this.padding = const EdgeInsets.symmetric(horizontal: 25, vertical: 22),
  });
  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  bool hover = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => hover = true),
    onExit: (_) => setState(() => hover = false),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: widget.filled
            ? Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: hover ? .85 : 1)
            : null,
      ),
      child: TextButton(
        onPressed: widget.onTap,
        style: TextButton.styleFrom(
          padding: widget.padding,
          backgroundColor: Colors.transparent,
          foregroundColor: widget.filled
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.onSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: widget.filled
                ? BorderSide.none
                : BorderSide(color: Theme.of(context).dividerColor),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                widget.label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Icon(widget.icon, size: 18),
          ],
        ),
      ),
    ),
  );
}
