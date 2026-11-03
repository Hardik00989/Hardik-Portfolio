import 'package:flutter/material.dart';

/// Static ambient light and grid, isolated from pointer and scrolling repaints.
class PortfolioBackdrop extends StatelessWidget {
  const PortfolioBackdrop({super.key});
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return IgnorePointer(
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _AmbientPainter(
            colors.primary,
            colors.tertiary,
            colors.onSurface,
            colors.brightness == Brightness.dark,
          ),
        ),
      ),
    );
  }
}

class _AmbientPainter extends CustomPainter {
  final Color primary, violet, grid;
  final bool dark;
  const _AmbientPainter(this.primary, this.violet, this.grid, this.dark);
  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    final radius = size.width.clamp(500.0, 1100.0) * .65;
    for (final light in [
      (point: Offset(size.width * .88, size.height * .15), color: primary),
      (point: Offset(size.width * .12, size.height * .85), color: violet),
    ]) {
      canvas.drawRect(
        bounds,
        Paint()
          ..shader = RadialGradient(
            colors: [
              light.color.withValues(alpha: dark ? .025 : .025),
              light.color.withValues(alpha: 0),
            ],
          ).createShader(Rect.fromCircle(center: light.point, radius: radius)),
      );
    }
    final paint = Paint()
      ..color = grid.withValues(alpha: 0.0)
      ..strokeWidth = .5;
    for (double x = 0; x < size.width; x += 64) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 64) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_AmbientPainter oldDelegate) =>
      primary != oldDelegate.primary ||
      violet != oldDelegate.violet ||
      grid != oldDelegate.grid ||
      dark != oldDelegate.dark;
}
