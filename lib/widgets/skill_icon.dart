import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Bundled technology marks, matched by skill name rather than list position.
class SkillIcon extends StatelessWidget {
  final String skill;
  const SkillIcon({super.key, required this.skill});

  static const assets = <String, String>{
    'Flutter': 'flutter.svg',
    'Dart': 'dart.svg',
    'Firebase': 'firebase.svg',
    'Riverpod': 'riverpod.svg',
    'Flame Engine': 'flame.png',
    'React Native': 'react.svg',
    'JavaScript': 'javascript.svg',
    'TypeScript': 'typescript.svg',
    'MySQL': 'mysql.svg',
    'FlutterFlow': 'flutterflow.png',
    'Postman': 'postman.svg',
    'Play Games Services': 'playgames.png',
    'AdMob': 'admob.svg',
    'Vercel': 'vercel.svg',
    'Android Studio': 'androidstudio.svg',
    'VS Code': 'vscode.svg',
  };

  @override
  Widget build(BuildContext context) {
    if (skill == 'HTML5 / CSS3') {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _svg(context, 'html5.svg', size: 20),
          const SizedBox(width: 3),
          _svg(context, 'css3.svg', size: 20),
        ],
      );
    }
    if (skill == 'Git / GitHub') {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _svg(context, 'git.svg', size: 20),
          const SizedBox(width: 3),
          _svg(context, 'github.svg', size: 20, monochrome: true),
        ],
      );
    }
    // These skills have no single technology logo; use meaningful symbols.
    if (skill == 'REST APIs') return const Icon(Icons.api_rounded, size: 24);
    if (skill == 'SQL') return const Icon(Icons.storage_rounded, size: 24);
    if (skill == 'Provider') {
      return const Icon(Icons.account_tree_outlined, size: 24);
    }

    final asset = assets[skill];
    if (asset == null) return const Icon(Icons.code_rounded, size: 24);
    if (asset.endsWith('.png')) {
      return SizedBox.square(
        dimension: 24,
        child: ClipRect(
          child: Image.asset(
            'assets/icons/$asset',
            width: 24,
            height: 24,
            fit: asset == 'flame.png' ? BoxFit.cover : BoxFit.contain,
            alignment: Alignment.centerLeft,
            excludeFromSemantics: true,
            errorBuilder: (context, error, stackTrace) => _fallback,
          ),
        ),
      );
    }
    return _svg(
      context,
      asset,
      monochrome: skill == 'Vercel',
      tint: skill == 'AdMob'
          ? const Color(0xFFEA4335)
          : skill == 'Play Games Services'
          ? const Color(0xFF34A853)
          : null,
    );
  }

  Widget _svg(
    BuildContext context,
    String asset, {
    double size = 24,
    bool monochrome = false,
    Color? tint,
  }) => SizedBox.square(
    dimension: size,
    child: SvgPicture.asset(
      'assets/icons/$asset',
      width: size,
      height: size,
      excludeFromSemantics: true,
      placeholderBuilder: (_) => SizedBox.square(dimension: size),
      errorBuilder: (_, error, stackTrace) => _fallback,
      colorFilter: monochrome || tint != null
          ? ColorFilter.mode(
              tint ?? Theme.of(context).colorScheme.onSurface,
              BlendMode.srcIn,
            )
          : null,
    ),
  );

  Widget get _fallback => Icon(switch (skill) {
    'Flame Engine' => Icons.local_fire_department_outlined,
    'Play Games Services' => Icons.sports_esports_outlined,
    'FlutterFlow' || 'Flutter' => Icons.flutter_dash,
    _ => Icons.code_rounded,
  }, size: 20);
}
