import 'package:flutter/material.dart';

/// A lightweight drawing of code becoming a mobile interface, not a project preview.
class AppDevelopmentIllustration extends StatelessWidget {
  const AppDevelopmentIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      image: true,
      label:
          'App development illustration: Dart code connected to a mobile interface wireframe',
      child: RepaintBoundary(
        child: AspectRatio(
          aspectRatio: 420 / 380,
          child: CustomPaint(
            painter: _DevelopmentPainter(
              foreground: colors.onSurface,
              background: colors.surface,
              accent: colors.primary,
            ),
          ),
        ),
      ),
    );
  }
}

class _DevelopmentPainter extends CustomPainter {
  final Color foreground, background, accent;
  const _DevelopmentPainter({
    required this.foreground,
    required this.background,
    required this.accent,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 420, size.height / 380);
    final line = foreground.withValues(alpha: .18);
    final faint = foreground.withValues(alpha: .07);
    final panel = Color.alphaBlend(
      foreground.withValues(alpha: .025),
      background,
    );

    void rect(Rect bounds, double radius, {Color? fill, Color? stroke}) {
      final shape = RRect.fromRectAndRadius(bounds, Radius.circular(radius));
      if (fill != null) canvas.drawRRect(shape, Paint()..color = fill);
      if (stroke != null) {
        canvas.drawRRect(
          shape,
          Paint()
            ..color = stroke
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1,
        );
      }
    }

    void rule(Offset start, Offset end, Color color, [double width = 1]) =>
        canvas.drawLine(
          start,
          end,
          Paint()
            ..color = color
            ..strokeWidth = width
            ..strokeCap = StrokeCap.round,
        );
    void text(
      String value,
      Offset at,
      double fontSize,
      Color color, {
      bool mono = false,
    }) {
      final painter = TextPainter(
        text: TextSpan(
          text: value,
          style: TextStyle(
            color: color,
            fontSize: fontSize,
            fontFamily: mono ? 'monospace' : 'Inter',
            height: 1.5,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(canvas, at);
      painter.dispose();
    }

    // Fine construction marks give the scene the feel of a UI working drawing.
    rule(const Offset(12, 36), const Offset(60, 36), line);
    rule(const Offset(12, 28), const Offset(12, 44), line);
    text(
      'CODE TO INTERFACE',
      const Offset(72, 28),
      9,
      foreground.withValues(alpha: .5),
    );

    // Phone outline with a neutral, abstract interface.
    rect(const Rect.fromLTWH(236, 59, 164, 300), 25, fill: panel, stroke: line);
    rect(
      const Rect.fromLTWH(246, 69, 144, 280),
      18,
      fill: background,
      stroke: faint,
    );
    rect(
      const Rect.fromLTWH(293, 78, 50, 5),
      3,
      fill: foreground.withValues(alpha: .22),
    );
    rule(const Offset(263, 110), const Offset(283, 110), accent, 3);
    canvas.drawCircle(const Offset(370, 110), 7, Paint()..color = faint);
    rect(
      const Rect.fromLTWH(261, 135, 114, 64),
      8,
      fill: accent.withValues(alpha: .1),
      stroke: accent.withValues(alpha: .28),
    );
    rule(
      const Offset(273, 153),
      const Offset(310, 153),
      accent.withValues(alpha: .65),
      4,
    );
    rule(const Offset(273, 168), const Offset(356, 168), line, 3);
    rule(const Offset(273, 181), const Offset(339, 181), line, 3);
    for (var i = 0; i < 3; i++) {
      final y = 217.0 + i * 31;
      rect(Rect.fromLTWH(261, y, 18, 18), 4, fill: faint);
      rule(Offset(290, y + 5), Offset(365, y + 5), line, 3);
      rule(Offset(290, y + 14), Offset(338, y + 14), faint, 3);
    }
    rect(const Rect.fromLTWH(278, 316, 80, 4), 2, fill: line);
    rule(const Offset(300, 339), const Offset(336, 339), line, 3);

    // Editor overlaps the phone slightly; the snippet is generic Flutter code.
    rect(const Rect.fromLTWH(9, 102, 248, 190), 8, fill: panel, stroke: line);
    rule(const Offset(9, 136), const Offset(257, 136), line);
    for (var i = 0; i < 3; i++) {
      canvas.drawCircle(
        Offset(25.0 + i * 11, 119),
        2,
        Paint()..color = foreground.withValues(alpha: .28),
      );
    }
    text(
      'main.dart',
      const Offset(70, 110),
      10,
      foreground.withValues(alpha: .6),
      mono: true,
    );
    const code = [
      'Widget build(context) {',
      '  return const MaterialApp(',
      '    home: Scaffold(',
      '      body: SizedBox(),',
      '    ),',
      '  );',
      '}',
    ];
    for (var i = 0; i < code.length; i++) {
      final y = 151.0 + i * 17;
      text(
        '${i + 1}',
        Offset(22, y),
        9,
        foreground.withValues(alpha: .24),
        mono: true,
      );
      text(
        code[i],
        Offset(41, y),
        10,
        i == 1 || i == 3 ? accent : foreground.withValues(alpha: .65),
        mono: true,
      );
    }

    final connector = Path()
      ..moveTo(92, 292)
      ..lineTo(92, 327)
      ..quadraticBezierTo(92, 333, 98, 333)
      ..lineTo(226, 333);
    canvas.drawPath(
      connector,
      Paint()
        ..color = accent.withValues(alpha: .4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
    rule(
      const Offset(220, 329),
      const Offset(226, 333),
      accent.withValues(alpha: .5),
    );
    rule(
      const Offset(220, 337),
      const Offset(226, 333),
      accent.withValues(alpha: .5),
    );
    text(
      'BUILD / REFINE / REPEAT',
      const Offset(26, 355),
      8,
      foreground.withValues(alpha: .4),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_DevelopmentPainter oldDelegate) =>
      foreground != oldDelegate.foreground ||
      background != oldDelegate.background ||
      accent != oldDelegate.accent;
}
