import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

enum LogoStyle { soft, neon }

/// Theme-aware brand mark. Its only local state is whether it is hovered.
class AnimatedLogo extends StatefulWidget {
  final String name;
  final VoidCallback onTap;
  final LogoStyle style;

  const AnimatedLogo({
    super.key,
    required this.onTap,
    this.name = 'Hardik',
    this.style = LogoStyle.soft,
  });

  @override
  State<AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final reduced = MediaQuery.disableAnimationsOf(context);
    final expanded = hovered && MediaQuery.sizeOf(context).width >= 600;
    final neon = widget.style == LogoStyle.neon;
    final duration = Duration(milliseconds: reduced ? 0 : 260);
    final gradient = LinearGradient(colors: [colors.primary, colors.tertiary]);
    final type = GoogleFonts.sora(
      fontSize: 28,
      fontWeight: FontWeight.w800,
      letterSpacing: -1.5,
      height: 1,
      color: neon ? colors.primary : colors.onSurface,
    );

    Widget letter = Text('h', style: type);
    Widget dot = ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: gradient.createShader,
      child: Text('.', style: type.copyWith(color: colors.onSurface)),
    );
    if (!reduced) {
      letter = letter
          .animate()
          .fadeIn(duration: 350.ms)
          .slideY(
            begin: .4,
            end: 0,
            duration: 450.ms,
            curve: Curves.easeOutCubic,
          );
      if (hovered) {
        dot = dot
            .animate(
              key: const ValueKey('pulse'),
              onPlay: (controller) => controller.repeat(reverse: true),
            )
            .scale(
              begin: const Offset(1, 1),
              end: const Offset(1.2, 1.2),
              duration: 650.ms,
              curve: Curves.easeInOut,
            );
      } else {
        dot = dot
            .animate(key: const ValueKey('entry'), delay: 220.ms)
            .fadeIn(duration: 120.ms)
            .slideY(
              begin: -.8,
              end: 0,
              duration: 320.ms,
              curve: Curves.bounceOut,
            )
            .then()
            .scale(
              begin: const Offset(.8, .8),
              end: const Offset(1, 1),
              duration: 450.ms,
              curve: Curves.elasticOut,
            );
      }
    }

    return Semantics(
      label: '${widget.name}, back to top',
      button: true,
      onTap: widget.onTap,
      excludeSemantics: true,
      child: Tooltip(
        message: 'Back to top',
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => hovered = true),
          onExit: (_) => setState(() => hovered = false),
          child: AnimatedScale(
            scale: hovered && !reduced ? 1.1 : 1,
            alignment: Alignment.centerLeft,
            duration: duration,
            child: AnimatedContainer(
              duration: duration,
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    colors.primary.withValues(
                      alpha: hovered || neon ? .85 : .3,
                    ),
                    colors.tertiary.withValues(
                      alpha: hovered || neon ? .8 : .2,
                    ),
                  ],
                ),
              ),
              child: Material(
                color: neon
                    ? colors.surface
                    : Color.alphaBlend(
                        colors.primary.withValues(alpha: .04),
                        colors.surface,
                      ),
                borderRadius: BorderRadius.circular(11),
                child: InkWell(
                  onTap: widget.onTap,
                  borderRadius: BorderRadius.circular(11),
                  hoverColor: colors.primary.withValues(alpha: .04),
                  focusColor: colors.primary.withValues(alpha: .12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        letter,
                        dot,
                        AnimatedSize(
                          duration: duration,
                          alignment: Alignment.centerLeft,
                          curve: Curves.easeOutCubic,
                          child: ClipRect(
                            child: SizedBox(
                              width: expanded ? 90 : 0,
                              child: AnimatedOpacity(
                                opacity: expanded ? 1 : 0,
                                duration: duration,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Text(
                                    widget.name,
                                    maxLines: 1,
                                    softWrap: false,
                                    overflow: TextOverflow.fade,
                                    style: type.copyWith(
                                      fontSize: 16,
                                      letterSpacing: -.5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
