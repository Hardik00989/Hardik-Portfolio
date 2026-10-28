import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../widgets/rotating_role.dart';
import '../utils/portfolio_data.dart';
import '../widgets/shared.dart';
import '../theme/app_theme.dart';

class HeroSection extends StatefulWidget {
  final VoidCallback viewWork, download;
  final ValueNotifier<double> scroll;
  const HeroSection({
    super.key,
    required this.viewWork,
    required this.download,
    required this.scroll,
  });
  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController motion = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 14),
  );
  bool visible = false;
  void syncMotion() {
    if (!mounted) return;
    if (!visible || MediaQuery.disableAnimationsOf(context)) {
      motion.stop();
    } else if (!motion.isAnimating) {
      motion.repeat();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    syncMotion();
  }

  @override
  void dispose() {
    motion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      final mobile = box.maxWidth < 700;
      final copy = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.circle, color: AppTokens.cyan, size: 7),
                SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'FLUTTER DEVELOPER / INDIA',
                    style: TextStyle(
                      fontSize: 9,
                      letterSpacing: 1.4,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Text(
            'Thoughtful code.\nMeaningful\nexperiences.',
            style: TextStyle(
              fontSize: mobile ? (box.maxWidth < 330 ? 43 : 52) : 76,
              height: 1.02,
              fontWeight: FontWeight.w500,
              letterSpacing: -4.5,
            ),
          ),
          const SizedBox(height: 25),
          Text(
            "Hey, I'm ${PortfolioData.name}.",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const SizedBox(height: 48, child: RotatingRole()),
          const SizedBox(height: 16),
          const Text(
            'Cross-platform apps, team tools, and mobile games.\nBuilt with Flutter, Dart, and attention to detail.',
            style: TextStyle(fontSize: 14, height: 1.8),
          ),
          const SizedBox(height: 30),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              AnimatedButton(label: 'Explore my work', onTap: widget.viewWork),
              AnimatedButton(
                label: 'Download CV',
                onTap: widget.download,
                filled: false,
                icon: Icons.south,
              ),
            ],
          ),
        ],
      );
      final art = RepaintBoundary(
        child: SizedBox(
          height: mobile ? 360 : 540,
          child: ValueListenableBuilder<double>(
            valueListenable: widget.scroll,
            builder: (context, offset, child) => Transform.translate(
              offset: Offset(0, -offset * .12),
              child: child,
            ),
            child: RepaintBoundary(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  RepaintBoundary(
                    child: CustomPaint(
                      size: const Size(510, 510),
                      painter: OrbitPainter(
                        motion,
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  Transform.rotate(
                    angle: -.14,
                    child: Container(
                      width: 240,
                      height: 325,
                      decoration: BoxDecoration(
                        color: AppTokens.ink,
                        border: Border.all(
                          color: AppTokens.cyan.withValues(alpha: .35),
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppTokens.violet.withValues(alpha: .15),
                            blurRadius: 45,
                            offset: const Offset(15, 25),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.code, color: AppTokens.cyan, size: 32),
                              Icon(
                                Icons.north_east,
                                color: Colors.white54,
                                size: 20,
                              ),
                            ],
                          ),
                          const Spacer(),
                          const Text(
                            'Built with care.\nMade to matter.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              height: 1.2,
                              letterSpacing: -1,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(height: 1, color: Colors.white24),
                          const SizedBox(height: 16),
                          const Text(
                            'DESIGN  ×  DEVELOPMENT',
                            style: TextStyle(
                              color: AppTokens.cyan,
                              fontSize: 9,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: mobile ? 2 : 8,
                    top: 80,
                    child: Transform.rotate(
                      angle: .12,
                      child: _tag(
                        '\u2726  A little detail. A lot of intention.',
                      ),
                    ),
                  ),
                  Positioned(
                    left: 5,
                    bottom: 80,
                    child: _tag('\u2197  Always curious. Always building.'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      return VisibilityDetector(
        key: const ValueKey('hero-motion-visibility'),
        onVisibilityChanged: (info) {
          visible = info.visibleFraction > 0;
          syncMotion();
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 65, bottom: 30),
          child: Column(
            children: [
              mobile
                  ? Column(
                      children: [
                        RevealOnScroll(child: copy),
                        art,
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(flex: 11, child: RevealOnScroll(child: copy)),
                        Expanded(flex: 10, child: art),
                      ],
                    ),
              const SizedBox(height: 45),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 20,
                children: [
                  Text(
                    'FLUTTER / FIREBASE / FLAME',
                    style: TextStyle(
                      fontSize: 9,
                      letterSpacing: 1.4,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  AnimatedBuilder(
                    animation: motion,
                    child: TextButton(
                      onPressed: widget.viewWork,
                      child: const Text(
                        'SCROLL TO EXPLORE  \u2193',
                        style: TextStyle(fontSize: 9, letterSpacing: 1),
                      ),
                    ),
                    builder: (context, child) => Transform.translate(
                      offset: Offset(
                        0,
                        math.sin(motion.value * 8 * math.pi) * 4,
                      ),
                      child: child,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              const Divider(),
            ],
          ),
        ),
      );
    },
  );
  Widget _tag(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
    decoration: BoxDecoration(
      color: AppTokens.cyan,
      borderRadius: BorderRadius.circular(5),
    ),
    child: Text(
      text,
      style: const TextStyle(
        color: AppTokens.ink,
        fontSize: 10,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

class OrbitPainter extends CustomPainter {
  final Animation<double> motion;
  final Color color;
  OrbitPainter(this.motion, this.color) : super(repaint: motion);
  @override
  void paint(Canvas canvas, Size size) {
    final phase = motion.value;
    final center = Offset(size.width / 2, size.height / 2);
    final r = math.min(size.width, size.height) * .44;
    final paint = Paint()
      ..color = color.withValues(alpha: .12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (var i = 0; i < 3; i++) {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(i * .8 + phase * .2);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset.zero,
          width: r * 2,
          height: r * (1 + i * .25),
        ),
        paint,
      );
      canvas.restore();
    }
    canvas.drawCircle(
      center +
          Offset(
            math.cos(phase * 2 * math.pi) * r,
            math.sin(phase * 2 * math.pi) * r,
          ),
      10,
      Paint()..color = AppTokens.cyan,
    );
    canvas.drawCircle(
      center + Offset(-r * .7, -r * .7),
      5,
      Paint()..color = color,
    );
    final star = center + Offset(r * .83, r * .7);
    for (var i = 0; i < 8; i++) {
      final a = i * math.pi / 4;
      canvas.drawLine(
        star + Offset(math.cos(a) * 8, math.sin(a) * 8),
        star + Offset(math.cos(a) * 25, math.sin(a) * 25),
        Paint()
          ..color = color
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(OrbitPainter oldDelegate) =>
      oldDelegate.motion != motion || oldDelegate.color != color;
}
