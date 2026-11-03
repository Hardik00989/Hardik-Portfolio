import 'package:flutter/material.dart';
import '../models/project.dart';
import '../theme/app_theme.dart';
import 'shared.dart';
import 'project_preview_image.dart';

class ProjectCard extends StatefulWidget {
  final Project project;
  final int index;
  final VoidCallback onView;
  final VoidCallback? onVisit;
  const ProjectCard({
    super.key,
    required this.project,
    required this.index,
    required this.onView,
    this.onVisit,
  });
  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool hover = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => hover = true),
    onExit: (_) => setState(() => hover = false),
    child: HoverSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: AppTokens.glass(
              context,
            ).copyWith(color: Theme.of(context).colorScheme.surface),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '0${widget.index + 1} / ${widget.project.previewAsset == null ? 'ILLUSTRATIVE PREVIEW' : widget.project.previewLabel}',
                  style: TextStyle(
                    color: Theme.of(context).hintColor,
                    fontSize: 9,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 16),
                AspectRatio(
                  aspectRatio: 16 / 10,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ColoredBox(
                      color: Theme.of(
                        context,
                      ).colorScheme.surface.withValues(alpha: .35),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: ClipRect(
                            child: AnimatedScale(
                              scale: hover ? 1.025 : 1,
                              duration: const Duration(milliseconds: 250),
                              child: widget.project.previewAsset != null
                                  ? ProjectPreviewImage(
                                      project: widget.project,
                                      errorBuilder: (_) => _fallbackPreview(),
                                    )
                                  : _fallbackPreview(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                AnimatedButton(
                  label: widget.onVisit == null
                      ? 'View project'
                      : widget.project.linkLabel,
                  onTap: widget.onVisit ?? widget.onView,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  icon: Icons.north_east,
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              if (widget.project.iconAsset != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: Image.asset(
                    widget.project.iconAsset!,
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                    excludeFromSemantics: true,
                    errorBuilder: (_, error, stackTrace) =>
                        const SizedBox.square(dimension: 30),
                  ),
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Text(
                  widget.project.title,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -.8,
                  ),
                ),
              ),
              IconButton(
                onPressed: widget.onView,
                tooltip: 'View ${widget.project.title}',
                icon: const Icon(Icons.north_east, size: 20),
              ),
            ],
          ),
          Text(
            widget.project.category,
            style: TextStyle(
              fontSize: 9,
              letterSpacing: 1.4,
              color: Theme.of(context).hintColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.project.description,
            style: TextStyle(
              fontSize: 13,
              height: 1.7,
              color: Theme.of(context).hintColor,
            ),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: widget.onView,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
            ),
            icon: const Icon(Icons.arrow_forward, size: 16),
            label: const Text('Explore project details'),
          ),
        ],
      ),
    ),
  );
  Widget _fallbackPreview() =>
      FittedBox(fit: BoxFit.scaleDown, child: _mockup());

  int get _previewKind => switch (widget.project.title) {
    'NovaStrike' => 0,
    'Blocktopus' => 1,
    _ => 2,
  };

  Widget _mockup() => Container(
    width: 220,
    height: 215,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: AppTokens.ink,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 25,
          offset: Offset(10, 20),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (widget.project.iconAsset != null) ...[
              Image.asset(
                widget.project.iconAsset!,
                width: 30,
                height: 30,
                excludeFromSemantics: true,
                errorBuilder: (_, error, stackTrace) =>
                    const SizedBox.square(dimension: 30),
              ),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Text(
                widget.project.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: SizedBox.expand(
            child: CustomPaint(painter: _ProjectPreviewPainter(_previewKind)),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          [
            '1,500 LEVELS / FLAME',
            '2,000 LEVELS / CUSTOMPAINTER',
            'ONE CODEBASE / EVERY SCREEN',
          ][_previewKind],
          style: const TextStyle(
            color: AppTokens.cyan,
            fontSize: 7,
            letterSpacing: .8,
          ),
        ),
      ],
    ),
  );
}

// Decorative project illustrations, not screenshots of the applications.
class _ProjectPreviewPainter extends CustomPainter {
  final int index;
  const _ProjectPreviewPainter(this.index);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppTokens.cyan;
    if (index == 0) {
      for (var i = 0; i < 25; i++) {
        canvas.drawCircle(
          Offset(
            (i * 43 % 179) / 179 * size.width,
            (i * 31 % 113) / 113 * size.height,
          ),
          i % 3 == 0 ? 2 : 1,
          Paint()..color = Colors.white54,
        );
      }
      final cx = size.width / 2;
      final cy = size.height * .7;
      canvas.drawPath(
        Path()
          ..moveTo(cx, cy - 25)
          ..lineTo(cx + 16, cy + 14)
          ..lineTo(cx, cy + 5)
          ..lineTo(cx - 16, cy + 14)
          ..close(),
        paint,
      );
      canvas.drawLine(
        Offset(cx, cy + 15),
        Offset(cx, cy + 29),
        Paint()
          ..color = Colors.orangeAccent
          ..strokeWidth = 3,
      );
    } else if (index == 1) {
      final cell = size.height / 5;
      for (var y = 0; y < 5; y++) {
        for (var x = 0; x < 7; x++) {
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(x * cell, y * cell, cell - 3, cell - 3),
              const Radius.circular(3),
            ),
            Paint()
              ..color = [
                AppTokens.cyan,
                const Color(0xFFB8A0D9),
                const Color(0xFFE8BA8A),
                Colors.white12,
              ][(x + y * 2) % 4],
          );
        }
      }
    } else {
      for (var i = 0; i < 3; i++) {
        final y = i * size.height / 3;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(0, y, size.width, size.height / 3 - 7),
            const Radius.circular(5),
          ),
          Paint()..color = Colors.white10,
        );
        canvas.drawCircle(Offset(15, y + 12), 5, paint);
        canvas.drawLine(
          Offset(30, y + 12),
          Offset(size.width - 20 - i * 15, y + 12),
          Paint()
            ..color = Colors.white54
            ..strokeWidth = 3,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_ProjectPreviewPainter oldDelegate) =>
      oldDelegate.index != index;
}
