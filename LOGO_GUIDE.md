# AnimatedLogo

Both variations share one reusable widget. The outlined neon style is installed in the navbar. Set `style: LogoStyle.soft` for the quieter version. The only widget-owned state is the hover flag; flutter_animate manages animation controllers and their disposal. Reduced motion skips entry/pulse animation and scaling and makes expansion immediate. Below 600px, the name stays hidden.

## Dependencies and font

`flutter_animate` and `google_fonts` are declared in pubspec.yaml. The Sora variable font is bundled as `assets/fonts/Sora-ExtraBold.ttf`, which google_fonts resolves for weight 800. Its license is included as `assets/fonts/Sora-OFL.txt`. No runtime font download is required.

## Navbar placement

Place the widget first in the navbar Row. The Row vertically centers children by default. The existing `go(0)` smoothly scrolls the controller to the first section.

```dart
SizedBox(
  height: 80,
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      AnimatedLogo(name: PortfolioData.name, onTap: () => go(0)),
      const Spacer(),
      // Navigation links, theme toggle, and mobile drawer button.
    ],
  ),
)
```

The duplicate contact CTA is hidden below 1200px so the hover name has space alongside the desktop navigation links.

## Outlined / neon variation

```dart
AnimatedLogo(
  name: PortfolioData.name,
  style: LogoStyle.neon,
  onTap: () => go(0),
)
```

This variation uses a stronger gradient outline, theme-primary letter color and an intensified hover glow. The soft variation uses theme-onSurface lettering with a softly tinted surface.

## Complete lib/widgets/animated_logo.dart

```dart
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
    this.style = LogoStyle.neon,
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
      fontSize: 32,
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
                boxShadow: [
                  BoxShadow(
                    color: colors.primary.withValues(
                      alpha: hovered ? .25 : .08,
                    ),
                    blurRadius: hovered ? 24 : 12,
                    spreadRadius: hovered && neon ? 2 : 0,
                  ),
                ],
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
                      horizontal: 12,
                      vertical: 10,
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

```
