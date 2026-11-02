```text
portfolio/
├── lib/
│   ├── main.dart
│   ├── models/project.dart
│   ├── screens/portfolio_screen.dart
│   ├── sections/
│   │   ├── hero_section.dart
│   │   ├── content_sections.dart
│   │   └── contact_section.dart
│   ├── widgets/
│   │   ├── shared.dart
│   │   └── project_card.dart
│   ├── utils/
│   │   ├── portfolio_data.dart
│   │   ├── download.dart
│   │   ├── download_stub.dart
│   │   └── download_web.dart
│   └── theme/app_theme.dart
├── assets/fonts/
│   ├── Inter.ttf
│   └── OFL.txt
├── web/
│   ├── index.html
│   ├── manifest.json
│   ├── favicon.svg
│   └── Hardik_resume.pdf
├── test/widget_test.dart
├── pubspec.yaml
├── pubspec.lock
├── firebase.json
├── SOURCE_CODE.md
└── README.md
```


# Complete source

The runnable files are written in this project. Inter.ttf and web/Hardik_resume.pdf are bundled binary assets. The supplied resume PDF is downloaded directly by the CV button. Font licensing is in assets/fonts/OFL.txt. See README.md for run and deployment instructions.


## pubspec.yaml

```yaml
name: portfolio
description: A responsive animated developer portfolio built with Flutter Web.
publish_to: none
version: 1.0.0+1
environment:
  sdk: ^3.12.2
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.9
  visibility_detector: ^0.4.0+2
  url_launcher: ^6.3.3
  web: ^1.1.1
  flutter_animate: ^4.5.2
  google_fonts: ^8.2.1
  flutter_svg: ^2.3.2
  flutter_riverpod: ^3.4.3
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
flutter:
  uses-material-design: true
  assets:
    - assets/images/hardik.jpg
    - assets/images/projects/
    - assets/icons/
    - assets/fonts/Sora-ExtraBold.ttf
  fonts:
    - family: Inter
      fonts:
        - asset: assets/fonts/Inter.ttf
```


## analysis_options.yaml

```yaml
# This file configures the analyzer, which statically analyzes Dart code to
# check for errors, warnings, and lints.
#
# The issues identified by the analyzer are surfaced in the UI of Dart-enabled
# IDEs (https://dart.dev/tools#ides-and-editors). The analyzer can also be
# invoked from the command line by running `flutter analyze`.

# The following line activates a set of recommended lints for Flutter apps,
# packages, and plugins designed to encourage good coding practices.
include: package:flutter_lints/flutter.yaml

linter:
  # The lint rules applied to this project can be customized in the
  # section below to disable rules from the `package:flutter_lints/flutter.yaml`
  # included above or to enable additional rules. A list of all available lints
  # and their documentation is published at https://dart.dev/lints.
  #
  # Instead of disabling a lint rule for the entire project in the
  # section below, it can also be suppressed for a single line of code
  # or a specific dart file by using the `// ignore: name_of_lint` and
  # `// ignore_for_file: name_of_lint` syntax on the line or in the file
  # producing the lint.
  rules:
    # avoid_print: false  # Uncomment to disable the `avoid_print` rule
    # prefer_single_quotes: true  # Uncomment to enable the `prefer_single_quotes` rule

# Additional information about this file can be found at
# https://dart.dev/guides/language/analysis-options
```


## lib/main.dart

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/portfolio_providers.dart';
import 'screens/portfolio_screen.dart';
import 'theme/app_theme.dart';

void main() => runApp(const ProviderScope(child: PortfolioApp()));

class PortfolioApp extends ConsumerWidget {
  const PortfolioApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Hardik - Flutter Developer',
    theme: AppTokens.theme(false),
    darkTheme: AppTokens.theme(true),
    themeMode: ref.watch(themeModeProvider),
    themeAnimationDuration: const Duration(milliseconds: 450),
    home: const PortfolioScreen(),
  );
}
```


## lib/models/project.dart

```dart
class Project {
  final String title, category, description, url;
  final String details;
  final String linkLabel, previewLabel;
  final String? previewAsset, iconAsset;
  final List<String> highlights, stack;
  final double previewTopCrop, previewBottomCrop, previewSourceAspectRatio;
  final int color;
  const Project(
    this.title,
    this.category,
    this.description,
    this.url,
    this.color, {
    this.details = '',
    this.linkLabel = 'Visit live app',
    this.previewLabel = 'GOOGLE PLAY SCREENSHOT',
    this.previewAsset,
    this.iconAsset,
    this.highlights = const [],
    this.stack = const [],
    this.previewTopCrop = 0,
    this.previewBottomCrop = 0,
    this.previewSourceAspectRatio = 16 / 9,
  });
}
```


## lib/theme/app_theme.dart

```dart
import 'package:flutter/material.dart';

abstract final class AppTokens {
  static const cyan = Color(0xFF53F5FF);
  static const violet = Color(0xFFB69CFF);
  static const ink = Color(0xFF080D1B);
  static const cream = Color(0xFFF1F3FC);
  static const maxWidth = 1200.0;
  static const sectionGap = 110.0;

  static BoxDecoration glass(BuildContext context, {double radius = 16}) {
    final colors = Theme.of(context).colorScheme;
    final dark = colors.brightness == Brightness.dark;
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          dark
              ? colors.onSurface.withValues(alpha: .065)
              : Colors.white.withValues(alpha: .85),
          dark
              ? colors.onSurface.withValues(alpha: .025)
              : Colors.white.withValues(alpha: .45),
        ],
      ),
      border: Border.all(
        color: colors.primary.withValues(alpha: dark ? .22 : .18),
      ),
      boxShadow: [
        BoxShadow(
          color: colors.shadow.withValues(alpha: dark ? .12 : .035),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  static ThemeData theme(bool dark) {
    final colors =
        ColorScheme.fromSeed(
          seedColor: cyan,
          brightness: dark ? Brightness.dark : Brightness.light,
          surface: dark ? ink : cream,
        ).copyWith(
          primary: dark ? cyan : const Color(0xFF006B79),
          onPrimary: dark ? ink : Colors.white,
          secondary: dark ? violet : const Color(0xFF6843C8),
          tertiary: dark ? violet : const Color(0xFF6843C8),
          onSurface: dark ? const Color(0xFFEAF0FF) : const Color(0xFF19233C),
        );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      scaffoldBackgroundColor: colors.surface,
      dividerColor: colors.primary.withValues(alpha: dark ? .2 : .14),
      hintColor: dark ? const Color(0xFFA6B4D0) : const Color(0xFF52617D),
      textTheme: ThemeData().textTheme.apply(
        fontFamily: 'Inter',
        bodyColor: colors.onSurface,
        displayColor: colors.onSurface,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: dark ? const Color(0xFF111A2E) : cream,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: colors.primary.withValues(alpha: .25)),
        ),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: dark ? const Color(0xFF10182A) : cream,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colors.primary.withValues(alpha: .08),
        side: BorderSide(color: colors.primary.withValues(alpha: .22)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.onSurface.withValues(alpha: dark ? .045 : .035),
        contentPadding: const EdgeInsets.all(20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primary.withValues(alpha: .2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primary.withValues(alpha: .2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primary, width: 1.5),
        ),
      ),
    );
  }
}
```


## lib/utils/portfolio_data.dart

```dart
import '../models/project.dart';

// Content summarized from Hardik's supplied resume.
abstract final class PortfolioData {
  static const name = 'Hardik';
  static const initials = 'h';
  static const email = 'vinayakhardik575@gmail.com';
  static const phone = '+91 70159 47351';
  static const phoneUri = 'tel:+917015947351';
  static const location = 'Sadhaura, India';
  static const linkedin = 'https://www.linkedin.com/in/hardikvinayak/';
  static const cvFile = 'Hardik_resume.pdf';
  static const roles = [
    'Flutter developer.',
    'Cross-platform app builder.',
    'Mobile game developer.',
  ];
  static const bio =
      "I am Hardik, a Flutter developer based in Sadhaura, India. I build cross-platform applications with Flutter and Dart, integrating REST APIs, Firebase, and responsive interfaces. My work spans employee management tools and mobile games built with Flame and CustomPainter.";
  static const about =
      'Disciplined, enthusiastic, and dedicated to my work, I enjoy collaborating with teams to improve application functionality and performance. I hold an MCA and a BCA from Maharishi Markandeshwar Institute of Computer Technology and Business Management, Mullana.';
  static const skills = [
    'Flutter',
    'Dart',
    'Firebase',
    'REST APIs',
    'Riverpod',
    'Provider',
    'Flame Engine',
    'React Native',
    'JavaScript',
    'TypeScript',
    'HTML5 / CSS3',
    'MySQL',
    'Git / GitHub',
    'FlutterFlow',
    'Postman',
    'Play Games Services',
    'AdMob',
    'Vercel',
    'Android Studio',
    'VS Code',
  ];
  static const skillGroups = [
    (
      title: 'Mobile & games',
      description: 'Cross-platform interfaces and custom game experiences.',
      skills: [
        'Flutter',
        'Dart',
        'React Native',
        'Flame Engine',
        'FlutterFlow',
      ],
    ),
    (
      title: 'State, APIs & data',
      description:
          'Application state, authentication, integrations, and storage.',
      skills: ['Riverpod', 'Provider', 'Firebase', 'REST APIs', 'MySQL'],
    ),
    (
      title: 'Web foundations',
      description: 'Web interfaces, typed JavaScript, and deployment.',
      skills: ['JavaScript', 'TypeScript', 'HTML5 / CSS3', 'Vercel'],
    ),
    (
      title: 'Tools & services',
      description: 'Development tooling, game services, and monetization.',
      skills: [
        'Git / GitHub',
        'Postman',
        'Play Games Services',
        'AdMob',
        'Android Studio',
        'VS Code',
      ],
    ),
  ];
  static const languages = 'English / Punjabi / Hindi';
  static const projects = [
    Project(
      'Team Pulse',
      'FLUTTER / FIREBASE',
      'An employee management app for mobile, web, and desktop, with geofenced attendance, leave and payroll, project tracking, and team communication.',
      'https://team-pulse-23aee.web.app/',
      0xFFF0E1D1,
      iconAsset: 'assets/images/projects/teampulse-icon.png',
      previewAsset: 'assets/images/projects/teampulse-dashboard.png',
      previewLabel: 'DASHBOARD SCREENSHOT',
      previewTopCrop: 182 / 1080,
      previewBottomCrop: 72 / 1080,
      stack: [
        'Flutter',
        'Dart',
        'Riverpod',
        'Firebase',
        'GoRouter',
        'Microsoft Graph',
      ],
      highlights: [
        'One codebase for mobile, web, and desktop.',
        'Geofenced attendance, leave balances, and automated payroll calculations.',
        'Projects, tasks, team notifications, and OneDrive integrations.',
      ],
      details:
          'April - July 2026. Built from one Flutter codebase with Dart, Riverpod, GoRouter, and Firebase Auth, Firestore, and Messaging. Includes geofenced check-in/out, live sessions, leave balances, automated payroll calculations, desktop activity tracking and session recovery, OneDrive screenshot uploads through Microsoft Graph, tasks, timelines, comments, attachments, document previews, announcements, push notifications, email digests, and reports. Hosted with Firebase Hosting.',
    ),
    Project(
      'Blocktopus',
      'FLUTTER / CUSTOMPAINTER',
      'A block puzzle game with a custom-painted board and octopus mascot, 2,000 validated levels, cloud saves, and achievements.',
      'https://play.google.com/store/apps/details?id=com.portalcrafter.blocktopus&hl=en_IN',
      0xFFE8DFF4,
      linkLabel: 'Get on Google Play',
      previewAsset: 'assets/images/projects/blocktopus-preview.png',
      iconAsset: 'assets/images/projects/blocktopus-icon.png',
      stack: [
        'Flutter',
        'Dart',
        'CustomPainter',
        'Play Games Services',
        'AdMob',
      ],
      highlights: [
        'Custom-painted board, mascot, and effects without a game engine.',
        '2,000 validated levels across 20 chapters.',
        'Cloud saves, achievements, leaderboards, and immutable undo snapshots.',
      ],
      details:
          'June 2026 - Present. Built for Android and iOS without a game engine, using CustomPainter for the board, mascot, and effects. Created an offline level generator and depth-limited solver for 2,000 levels across 20 chapters. Integrated conflict-merging cloud saves, 20 achievements, three leaderboards, and AdMob. Added immutable undo snapshots, a coach-mark tutorial, and a pitch-ladder audio engine. Built for a 40 MB app size and 60 fps on low-end hardware.',
    ),
    Project(
      'NovaStrike',
      'FLUTTER / FLAME',
      'A mobile space shooter with a generated 1,500-level campaign, a custom pseudo-3D renderer, object pooling, and accessibility options.',
      'https://play.google.com/store/apps/details?id=com.portalcrafter.novastrike&hl=en_IN',
      0xFFE1E7DA,
      linkLabel: 'Get on Google Play',
      previewAsset: 'assets/images/projects/novastrike-preview.png',
      iconAsset: 'assets/images/projects/novastrike-icon.png',
      stack: [
        'Flutter',
        'Dart',
        'Flame Engine',
        'Play Games Services',
        'AdMob',
      ],
      highlights: [
        '1,500-level campaign generated deterministically from level numbers.',
        'Pseudo-3D rendering and object pooling for dense bullet patterns.',
        'Accessibility options, layered audio, and 400+ game logic and UI tests.',
      ],
      details:
          'July 2026 - Present. Built a deterministic campaign generator seeded by level number. Designed a pseudo-3D renderer and object pooling for 60 fps with 400 bullets on low-end Android hardware. Added master, music, and effects audio channels with ducking and throttling; reduced camera shake, high-contrast enemy fire, and larger bullets; Google Play Games Services and AdMob. Includes 400+ tests covering game logic and UI.',
    ),
  ];
  static const capabilities = [
    (
      icon: 'Flutter',
      title: 'Cross-platform applications',
      description:
          'Responsive apps that bring attendance, tasks, authentication, and everyday workflows together across mobile, web, and desktop.',
      tools: ['Flutter / Dart', 'Riverpod / Provider', 'REST APIs'],
    ),
    (
      icon: 'Flame Engine',
      title: 'Mobile game engineering',
      description:
          'Custom-rendered games with generated levels, carefully managed state, audio systems, accessibility options, and game-service integrations.',
      tools: ['Flame Engine', 'CustomPainter', 'Play Games Services'],
    ),
    (
      icon: 'Firebase',
      title: 'Connected product features',
      description:
          'Cloud-backed features for sign-in, storage, notifications, and third-party services, built into the experience rather than bolted on afterward.',
      tools: ['Firebase', 'Microsoft Graph', 'AdMob'],
    ),
  ];

  static const projectStories = {
    'Team Pulse': (
      challenge:
          'Bring attendance, leave, payroll, projects, and communication into a single employee-management experience that works across devices.',
      approach:
          'Used Flutter with Riverpod and GoRouter for the app, backed by Firebase Auth, Firestore, and Messaging. Geofenced check-in/out and live sessions connect attendance to the rest of the workflow.',
      engineering:
          'Desktop activity tracking includes break reminders and unfinished-session recovery. Screenshot uploads use OneDrive through Microsoft Graph, while project tasks support comments, attachments, and document previews.',
      outcome:
          'One codebase serving mobile, web, and desktop, with a live web application available to explore.',
    ),
    'Blocktopus': (
      challenge:
          'Build a complete block puzzle game without a game engine, including its board, octopus mascot, effects, progression, and persistence.',
      approach:
          'Rendered the experience with CustomPainter. An offline generator and depth-limited solver produced 2,000 levels across 20 chapters, rejecting unsolvable, trivial, and greedy-solvable puzzles.',
      engineering:
          'Immutable state snapshots power undo. Cloud saves merge conflicts, while achievements, leaderboards, a coach-mark tutorial, and pitch-ladder audio support progression and feedback.',
      outcome:
          'Published on Google Play, combining custom rendering, cloud progression, and a 40 MB app footprint.',
    ),
    'NovaStrike': (
      challenge:
          'Create a space shooter with a large campaign and dense action while keeping content generation, rendering, audio, and accessibility manageable.',
      approach:
          'Generated a deterministic 1,500-level campaign from level-number seeds. A custom pseudo-3D renderer and object pooling support dense bullet patterns without hand-authoring every stage.',
      engineering:
          'The audio system separates master, music, and effects channels with ducking and throttling. Accessibility options reduce camera shake and increase enemy-fire contrast and bullet size. 400+ tests cover game logic and UI.',
      outcome:
          'A published Google Play game combining generated content, custom rendering, game services, and AdMob integrations.',
    ),
  };

  static const engineeringHighlights = [
    (
      value: '1,500',
      label: 'Generated campaign levels',
      project: 'NovaStrike',
      detail:
          'Deterministic level-number seeds replace hand-authored campaign content.',
    ),
    (
      value: '2,000',
      label: 'Validated puzzle levels',
      project: 'Blocktopus',
      detail:
          'An offline generator and solver validate progression across 20 chapters.',
    ),
    (
      value: '400+',
      label: 'Game logic & UI tests',
      project: 'NovaStrike',
      detail:
          'Automated checks cover the systems behind the space-shooter experience.',
    ),
    (
      value: '3',
      label: 'Platform families',
      project: 'Team Pulse',
      detail: 'Mobile, web, and desktop experiences from one Flutter codebase.',
    ),
  ];

  static const timeline = [
    (
      date: 'MAR 2026 - PRESENT',
      title: 'Flutter Developer | VR Automations',
      description:
          'Mohali, Punjab. Develop and maintain cross-platform Flutter and Dart applications, integrate REST APIs, and build responsive interfaces. Work on employee management, activity tracking, authentication, state management, and reusable UI components in collaboration with the development team.',
    ),
    (
      date: 'JAN - MAR 2026',
      title: 'Flutter Developer | SGN Solutions',
      description:
          'Zafferpur, Ambala. Built scalable mobile apps with Dart, integrated third-party APIs, optimized responsive UI/UX, and managed full-stack deployments.',
    ),
    (
      date: 'AUG 2023 - JUN 2025',
      title: 'Master of Computer Applications',
      description:
          'Maharishi Markandeshwar Institute of Computer Technology and Business Management, Mullana, Ambala.',
    ),
    (
      date: 'AUG 2020 - JUN 2023',
      title: 'Bachelor of Computer Applications',
      description:
          'Maharishi Markandeshwar Institute of Computer Technology and Business Management, Mullana, Ambala.',
    ),
  ];
}
```


## lib/utils/download.dart

```dart
﻿export 'download_stub.dart' if (dart.library.js_interop) 'download_web.dart';
```


## lib/utils/download_stub.dart

```dart
import 'portfolio_data.dart';
import 'package:url_launcher/url_launcher.dart';

void downloadCv() {
  launchUrl(Uri.base.resolve(PortfolioData.cvFile));
}
```


## lib/utils/download_web.dart

```dart
import 'portfolio_data.dart';
import 'package:web/web.dart' as web;

void downloadCv() {
  final link = web.HTMLAnchorElement()
    ..href = Uri.base.resolve(PortfolioData.cvFile).toString()
    ..download = PortfolioData.cvFile;
  web.document.body?.append(link);
  link.click();
  link.remove();
}
```


## lib/widgets/shared.dart

```dart
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
        offset: visible ? Offset.zero : const Offset(0, .08),
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeOutCubic,
        child: AnimatedScale(
          scale: visible ? 1 : .98,
          duration: const Duration(milliseconds: 650),
          child: widget.child,
        ),
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
          letterSpacing: 2,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 22),
      Text(
        title,
        style: TextStyle(
          fontSize: MediaQuery.sizeOf(context).width < 600 ? 36 : 52,
          height: 1.1,
          letterSpacing: -2.5,
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
        ..translateByDouble(0, hover ? -6 : 0, 0, 1)
        ..rotateZ(hover && widget.tilt ? -.025 : 0),
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
        gradient: widget.filled
            ? LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.tertiary,
                ],
              )
            : null,
        boxShadow: hover && widget.filled
            ? [
                BoxShadow(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: .3),
                  blurRadius: 24,
                ),
              ]
            : [],
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
```


## lib/widgets/project_card.dart

```dart
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
            decoration: AppTokens.glass(context).copyWith(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.alphaBlend(
                    Color(widget.project.color).withValues(alpha: .1),
                    Theme.of(context).colorScheme.surface,
                  ),
                  Color.alphaBlend(
                    Theme.of(
                      context,
                    ).colorScheme.tertiary.withValues(alpha: .1),
                    Theme.of(context).colorScheme.surface,
                  ),
                ],
              ),
            ),
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
```


## lib/sections/hero_section.dart

```dart
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
```


## lib/sections/content_sections.dart

```dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/portfolio_data.dart';
import '../widgets/shared.dart';
import '../widgets/skill_icon.dart';
import '../theme/app_theme.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      final portrait = HoverSurface(
        tilt: true,
        child: Container(
          height: 370,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/hardik.jpg',
                  fit: BoxFit.cover,
                  alignment: const Alignment(0, -.25),
                  semanticLabel: 'Portrait of Hardik, Flutter developer',
                  filterQuality: FilterQuality.medium,
                ),
              ),
              Positioned(
                left: 22,
                bottom: 22,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  color: Theme.of(
                    context,
                  ).colorScheme.surface.withValues(alpha: .9),
                  child: Text(
                    'HARDIK / FLUTTER DEVELOPER',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 10,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      final text = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            number: '01',
            label: 'A LITTLE ABOUT ME',
            title: 'Cross-platform apps.\nPlayful experiences.',
          ),
          const SizedBox(height: 25),
          const Text(
            PortfolioData.bio,
            style: TextStyle(fontSize: 15, height: 1.9),
          ),
          const SizedBox(height: 16),
          Text(
            PortfolioData.about,
            style: TextStyle(
              fontSize: 14,
              height: 1.8,
              color: Theme.of(context).hintColor,
            ),
          ),
          const SizedBox(height: 30),
          const Wrap(
            spacing: 45,
            runSpacing: 20,
            children: [
              CountStat(value: 3, label: 'Featured projects', suffix: ''),
              CountStat(value: 2, label: 'Professional roles', suffix: ''),
              CountStat(value: 2, label: 'Degrees earned', suffix: ''),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Based in ${PortfolioData.location} / ${PortfolioData.languages}',
            style: TextStyle(
              fontSize: 12,
              height: 1.6,
              color: Theme.of(context).hintColor,
            ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () => launchUrl(
              Uri.base.resolve(PortfolioData.cvFile),
              webOnlyWindowName: '_blank',
            ),
            icon: const Icon(Icons.description_outlined, size: 18),
            label: const Text('View r\u00e9sum\u00e9'),
          ),
        ],
      );
      return box.maxWidth < 700
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [text, const SizedBox(height: 35), portrait],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 4, child: portrait),
                const SizedBox(width: 75),
                Expanded(flex: 6, child: text),
              ],
            );
    },
  );
}

class CountStat extends StatefulWidget {
  final int value;
  final String label, suffix;
  const CountStat({
    super.key,
    required this.value,
    required this.label,
    this.suffix = '+',
  });
  @override
  State<CountStat> createState() => _CountStatState();
}

class _CountStatState extends State<CountStat> {
  bool started = false;
  @override
  Widget build(BuildContext context) => RevealOnScroll(
    onReveal: () => setState(() => started = true),
    child: TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: started ? widget.value.toDouble() : 0),
      duration: Duration(
        milliseconds: MediaQuery.disableAnimationsOf(context) ? 0 : 1800,
      ),
      builder: (context, value, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${value.round()}${widget.suffix}',
            style: const TextStyle(fontSize: 37, letterSpacing: -2),
          ),
          const SizedBox(height: 6),
          Text(
            widget.label,
            style: TextStyle(fontSize: 11, color: Theme.of(context).hintColor),
          ),
        ],
      ),
    ),
  );
}

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SectionTitle(
        number: '05',
        label: 'MY TOOLKIT',
        title: 'The right tools.\nThe right touch.',
      ),
      const SizedBox(height: 20),
      Text(
        'The technologies I use, grouped by what they help me build.',
        style: TextStyle(
          color: Theme.of(context).hintColor,
          fontSize: 14,
          height: 1.7,
        ),
      ),
      const SizedBox(height: 32),
      LayoutBuilder(
        builder: (context, box) {
          final columns = box.maxWidth >= 800 ? 2 : 1;
          final width = (box.maxWidth - (columns - 1) * 20) / columns;
          return Wrap(
            spacing: 20,
            runSpacing: 20,
            children: List.generate(PortfolioData.skillGroups.length, (i) {
              final group = PortfolioData.skillGroups[i];
              return SizedBox(
                width: width,
                child: RevealOnScroll(
                  delay: i * 70,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: AppTokens.glass(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          group.title,
                          style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -.6,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          group.description,
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.7,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        const SizedBox(height: 22),
                        Wrap(
                          spacing: 8,
                          runSpacing: 10,
                          children: group.skills
                              .map(
                                (skill) => HoverSurface(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: .035),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SkillIcon(skill: skill),
                                        const SizedBox(width: 10),
                                        Flexible(
                                          child: Text(
                                            skill,
                                            style: const TextStyle(
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    ],
  );
}

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SectionTitle(
        number: '06',
        label: 'EXPERIENCE & EDUCATION',
        title: 'Where I have worked.\nWhat I have learned.',
      ),
      const SizedBox(height: 20),
      Text(
        'Professional work and the education behind it.',
        style: TextStyle(
          fontSize: 14,
          height: 1.7,
          color: Theme.of(context).hintColor,
        ),
      ),
      const SizedBox(height: 35),
      LayoutBuilder(
        builder: (context, box) {
          final work = _JourneyColumn(
            label: 'PROFESSIONAL EXPERIENCE',
            entries: PortfolioData.timeline.take(2).toList(),
          );
          final education = _JourneyColumn(
            label: 'EDUCATION',
            entries: PortfolioData.timeline.skip(2).toList(),
          );
          return box.maxWidth < 800
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [work, const SizedBox(height: 28), education],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: work),
                    const SizedBox(width: 28),
                    Expanded(child: education),
                  ],
                );
        },
      ),
    ],
  );
}

class _JourneyColumn extends StatelessWidget {
  final String label;
  final List<({String date, String title, String description})> entries;
  const _JourneyColumn({required this.label, required this.entries});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          letterSpacing: 1.8,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 20),
      ...List.generate(entries.length, (i) {
        final entry = entries[i];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: RevealOnScroll(
            delay: i * 100,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: AppTokens.glass(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.circle, size: 7, color: AppTokens.cyan),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          entry.date,
                          style: TextStyle(
                            fontSize: 10,
                            letterSpacing: 1,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    entry.title,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    entry.description,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.8,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    ],
  );
}
```


## lib/sections/contact_section.dart

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/portfolio_providers.dart';
import '../theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/portfolio_data.dart';
import '../widgets/shared.dart';

class ContactSection extends ConsumerStatefulWidget {
  const ContactSection({super.key});
  @override
  ConsumerState<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends ConsumerState<ContactSection> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController(),
      email = TextEditingController(),
      message = TextEditingController();
  @override
  void dispose() {
    name.dispose();
    email.dispose();
    message.dispose();
    super.dispose();
  }

  Future<void> send() async {
    if (!form.currentState!.validate()) return;
    await ref.read(contactSubmissionProvider.notifier).submit(() async {
      final uri = Uri(
        scheme: 'mailto',
        path: PortfolioData.email,
        query:
            'subject=${Uri.encodeComponent('Portfolio enquiry from ${name.text.trim()}')}&body=${Uri.encodeComponent('From: ${email.text.trim()}\n\n${message.text.trim()}')}',
      );
      try {
        final success = await launchUrl(uri);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                success
                    ? 'Your email app is ready. Send your message there.'
                    : 'No email app found. Please email ${PortfolioData.email} directly.',
              ),
            ),
          );
        }
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please email ${PortfolioData.email} directly.'),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final sending = ref.watch(contactSubmissionProvider);
    return LayoutBuilder(
      builder: (context, box) {
        final intro = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(
              number: '09',
              label: 'LET’S MAKE SOMETHING',
              title: 'Good things start\nwith a hello.',
            ),
            const SizedBox(height: 25),
            Text(
              'Have a project in mind, a question, or just a good idea?\nI’d love to hear about it.',
              style: TextStyle(
                fontSize: 14,
                height: 1.8,
                color: Theme.of(context).hintColor,
              ),
            ),
            const SizedBox(height: 25),
            SelectableText(
              PortfolioData.email,
              style: const TextStyle(
                fontSize: 16,
                decoration: TextDecoration.underline,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                AnimatedButton(
                  label: 'Email me',
                  filled: false,
                  icon: Icons.mail_outline,
                  onTap: () => launchUrl(
                    Uri(scheme: 'mailto', path: PortfolioData.email),
                  ),
                ),
                AnimatedButton(
                  label: 'Call',
                  filled: false,
                  icon: Icons.phone_outlined,
                  onTap: () => launchUrl(Uri.parse(PortfolioData.phoneUri)),
                ),
                AnimatedButton(
                  label: 'LinkedIn',
                  filled: false,
                  onTap: () => launchUrl(Uri.parse(PortfolioData.linkedin)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              '${PortfolioData.location} / ${PortfolioData.phone}',
              style: TextStyle(
                fontSize: 10,
                color: Theme.of(context).hintColor,
              ),
            ),
          ],
        );
        final fields = Container(
          padding: const EdgeInsets.all(24),
          decoration: AppTokens.glass(context),
          child: Form(
            key: form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: name,
                  autofillHints: const [AutofillHints.name],
                  decoration: const InputDecoration(labelText: 'Your name'),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Please enter your name.'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: email,
                  autofillHints: const [AutofillHints.email],
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email address'),
                  validator: (v) =>
                      v == null ||
                          !RegExp(
                            r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                          ).hasMatch(v.trim())
                      ? 'Enter a valid email address.'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: message,
                  minLines: 4,
                  maxLines: 7,
                  decoration: const InputDecoration(
                    labelText: 'Tell me about your idea',
                    alignLabelWithHint: true,
                  ),
                  validator: (v) => v == null || v.trim().length < 10
                      ? 'Please write at least 10 characters.'
                      : null,
                ),
                const SizedBox(height: 20),
                AnimatedButton(
                  label: sending ? 'Opening email…' : 'Let’s talk',
                  onTap: () {
                    if (!sending) send();
                  },
                ),
                const SizedBox(height: 12),
                Text(
                  'Opens your email app. No messages are stored on this site.',
                  style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
          ),
        );
        return box.maxWidth < 750
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [intro, const SizedBox(height: 35), fields],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: intro),
                  const SizedBox(width: 65),
                  Expanded(child: fields),
                ],
              );
      },
    );
  }
}
```


## lib/screens/portfolio_screen.dart

```dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/portfolio_providers.dart';
import 'package:url_launcher/url_launcher.dart';
import '../sections/hero_section.dart';
import '../sections/content_sections.dart';
import '../sections/extended_sections.dart';
import '../sections/contact_section.dart';
import '../widgets/shared.dart';
import '../widgets/animated_logo.dart';
import '../widgets/project_card.dart';
import '../widgets/project_details.dart';
import '../widgets/portfolio_backdrop.dart';
import '../utils/portfolio_data.dart';
import '../utils/download.dart';
import '../theme/app_theme.dart';

class PortfolioScreen extends ConsumerStatefulWidget {
  const PortfolioScreen({super.key});
  @override
  ConsumerState<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends ConsumerState<PortfolioScreen> {
  late final PortfolioViewport viewport;
  ScrollController get controller => viewport.controller;
  ValueNotifier<double> get scroll => viewport.parallax;
  ValueNotifier<Offset?> get cursor => viewport.cursor;
  final keys = List.generate(10, (_) => GlobalKey());
  static const labels = [
    'Home',
    'About',
    'Expertise',
    'Work',
    'Case studies',
    'Skills',
    'Experience',
    'Highlights',
    'Resume',
    'Contact',
  ];
  @override
  void initState() {
    super.initState();
    viewport = ref.read(viewportProvider);
    controller.addListener(onScroll);
  }

  void onScroll() {
    if (!mounted) return;
    scroll.value = controller.offset.clamp(0.0, 1100.0);
    int next = ref.read(navigationProvider).activeSection;
    for (var i = 0; i < keys.length; i++) {
      final box = keys[i].currentContext?.findRenderObject() as RenderBox?;
      if (box != null && box.localToGlobal(Offset.zero).dy <= 170) next = i;
    }
    final blur = controller.offset > 20;
    ref.read(navigationProvider.notifier).update(section: next, scrolled: blur);
  }

  void go(int index) {
    final box = keys[index].currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    controller.animateTo(
      (controller.offset + box.localToGlobal(Offset.zero).dy - 105).clamp(
        0,
        controller.position.maxScrollExtent,
      ),
      duration: Duration(
        milliseconds: MediaQuery.disableAnimationsOf(context) ? 1 : 850,
      ),
      curve: Curves.easeInOutCubic,
    );
  }

  Future<void> openProject(int i) => showDialog<void>(
    context: context,
    builder: (_) => ProjectDetails(project: PortfolioData.projects[i]),
  );

  @override
  void dispose() {
    controller.removeListener(onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(viewportProvider);
    return LayoutBuilder(
      builder: (context, box) {
        final mobile = box.maxWidth < 600;
        final desktop = box.maxWidth > 1024;
        final padding = mobile
            ? 24.0
            : box.maxWidth < 1025
            ? 40.0
            : 64.0;
        return Scaffold(
          endDrawer: Drawer(
            child: SafeArea(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Text('Explore', style: TextStyle(fontSize: 26)),
                  ),
                  ...List.generate(
                    labels.length,
                    (i) => Consumer(
                      builder: (context, ref, _) => ListTile(
                        title: Text(labels[i]),
                        selected: ref.watch(
                          navigationProvider.select(
                            (state) => state.activeSection == i,
                          ),
                        ),
                        trailing: const Icon(Icons.north_east),
                        onTap: () {
                          Navigator.pop(context);
                          go(i);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: MouseRegion(
            onHover: (event) {
              if (desktop && !MediaQuery.disableAnimationsOf(context)) {
                cursor.value = event.localPosition;
              }
            },
            onExit: (_) => cursor.value = null,
            child: Stack(
              children: [
                const Positioned.fill(child: PortfolioBackdrop()),
                SingleChildScrollView(
                  controller: controller,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: AppTokens.maxWidth + 128,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: padding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 75),
                            SizedBox(
                              key: keys[0],
                              child: HeroSection(
                                scroll: scroll,
                                viewWork: () => go(3),
                                download: downloadCv,
                              ),
                            ),
                            _section(1, const AboutSection()),
                            _section(2, const ExpertiseSection()),
                            _section(
                              3,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Expanded(
                                        child: SectionTitle(
                                          number: '03',
                                          label: 'SELECTED WORK',
                                          title:
                                              'A few things\nI’ve put into the world.',
                                        ),
                                      ),
                                      if (!mobile)
                                        const Text(
                                          'Mobile games and team tools\nDesign meets development.',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontSize: 12,
                                            height: 1.8,
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 38),
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      final columns = constraints.maxWidth < 550
                                          ? 1
                                          : constraints.maxWidth < 900
                                          ? 2
                                          : 3;
                                      final width =
                                          (constraints.maxWidth -
                                              (columns - 1) * 25) /
                                          columns;
                                      return Wrap(
                                        spacing: 25,
                                        runSpacing: 40,
                                        children: List.generate(
                                          PortfolioData.projects.length,
                                          (i) => SizedBox(
                                            width: width,
                                            child: RevealOnScroll(
                                              delay: i * 100,
                                              child: ProjectCard(
                                                project:
                                                    PortfolioData.projects[i],
                                                index: i,
                                                onView: () => openProject(i),
                                                onVisit:
                                                    PortfolioData
                                                        .projects[i]
                                                        .url
                                                        .isEmpty
                                                    ? null
                                                    : () => launchUrl(
                                                        Uri.parse(
                                                          PortfolioData
                                                              .projects[i]
                                                              .url,
                                                        ),
                                                        mode: LaunchMode
                                                            .externalApplication,
                                                        webOnlyWindowName:
                                                            '_blank',
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            _section(4, const CaseStudiesSection()),
                            _section(5, const SkillsSection()),
                            _section(6, const ExperienceSection()),
                            _section(7, const HighlightsSection()),
                            _section(8, const ResumeSection()),
                            _section(9, const ContactSection()),
                            const SizedBox(height: 70),
                            const Divider(),
                            const SizedBox(height: 20),
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 25,
                              runSpacing: 15,
                              children: [
                                Text(
                                  '${PortfolioData.initials}.',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -2,
                                  ),
                                ),
                                Text(
                                  '© ${DateTime.now().year} ${PortfolioData.name}. Built with care & Flutter.',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => go(0),
                                  child: const Text(
                                    'BACK TO TOP  \u2191',
                                    style: TextStyle(
                                      fontSize: 10,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 25),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: _NavbarBackdrop(desktop: desktop),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: AppTokens.maxWidth + 128,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: padding),
                        child: SizedBox(
                          height: 80,
                          child: Row(
                            children: [
                              SizedBox(
                                width: mobile ? 96 : 184,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: RepaintBoundary(
                                    child: AnimatedLogo(
                                      name: PortfolioData.name,
                                      onTap: () => go(0),
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              if (desktop)
                                ...List.generate(5, (i) {
                                  final index = [1, 3, 5, 6, 9][i];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Consumer(
                                      builder: (context, ref, _) => NavLink(
                                        label: labels[index],
                                        active: ref.watch(
                                          navigationProvider.select(
                                            (state) =>
                                                state.activeSection == index,
                                          ),
                                        ),
                                        onTap: () => go(index),
                                      ),
                                    ),
                                  );
                                }),
                              if (desktop) const SizedBox(width: 24),
                              if (desktop)
                                PopupMenuButton<int>(
                                  tooltip: 'More sections',
                                  icon: const Icon(Icons.more_horiz, size: 20),
                                  onSelected: go,
                                  itemBuilder: (_) => [2, 4, 7, 8]
                                      .map(
                                        (i) => PopupMenuItem(
                                          value: i,
                                          child: Text(labels[i]),
                                        ),
                                      )
                                      .toList(),
                                ),
                              const _ThemeToggle(),
                              if (desktop && box.maxWidth >= 1360) ...[
                                const SizedBox(width: 18),
                                AnimatedButton(
                                  label: 'Let’s talk',
                                  onTap: () => go(9),
                                ),
                              ],
                              if (!desktop)
                                Builder(
                                  builder: (context) => IconButton(
                                    tooltip: 'Open navigation',
                                    onPressed: () =>
                                        Scaffold.of(context).openEndDrawer(),
                                    icon: const Icon(Icons.menu),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (desktop)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: RepaintBoundary(
                        child: CustomPaint(
                          painter: _CursorPainter(
                            cursor,
                            Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: .5),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _section(int index, Widget child) => Padding(
    key: keys[index],
    padding: const EdgeInsets.only(top: AppTokens.sectionGap),
    child: RevealOnScroll(child: child),
  );
}

class NavLink extends StatefulWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const NavLink({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });
  @override
  State<NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<NavLink> {
  bool hover = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => hover = true),
    onExit: (_) => setState(() => hover = false),
    child: TextButton(
      onPressed: widget.onTap,
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.label, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 5),
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: hover || widget.active ? 24 : 0,
            height: 2,
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    ),
  );
}

// Pointer movement invalidates this paint layer only: no widget rebuild/layout.
class _CursorPainter extends CustomPainter {
  final ValueNotifier<Offset?> position;
  final Color color;
  _CursorPainter(this.position, this.color) : super(repaint: position);
  @override
  void paint(Canvas canvas, Size size) {
    final point = position.value;
    if (point == null) return;
    canvas.drawCircle(
      point,
      15,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(_CursorPainter oldDelegate) =>
      oldDelegate.position != position || oldDelegate.color != color;
}

class _ThemeToggle extends ConsumerWidget {
  const _ThemeToggle();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dark = ref.watch(themeModeProvider) == ThemeMode.dark;
    return IconButton(
      tooltip: dark ? 'Switch to light theme' : 'Switch to dark theme',
      onPressed: ref.read(themeModeProvider.notifier).toggle,
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Icon(
          dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          key: ValueKey(dark),
          size: 19,
        ),
      ),
    );
  }
}

class _NavbarBackdrop extends ConsumerWidget {
  final bool desktop;
  const _NavbarBackdrop({required this.desktop});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrolled = ref.watch(
      navigationProvider.select((state) => state.scrolled),
    );
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: scrolled && desktop ? 6 : 0,
          sigmaY: scrolled && desktop ? 6 : 0,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 80,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor.withValues(
              alpha: scrolled && desktop ? .84 : .94,
            ),
            border: Border(
              bottom: BorderSide(
                color: Theme.of(
                  context,
                ).dividerColor.withValues(alpha: scrolled ? .15 : 0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```


## web/index.html

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <base href="$FLUTTER_BASE_HREF">
  <meta charset="UTF-8">
  <meta content="IE=Edge" http-equiv="X-UA-Compatible">
  <meta name="description" content="Hardik, Flutter developer in Sadhaura, India. Explore cross-platform applications, Flutter and Flame games, experience, and contact details.">
  <meta name="theme-color" content="#080D1B">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Hardik — Flutter Developer</title>
  <link rel="icon" href="favicon.svg" type="image/svg+xml">
  <link rel="manifest" href="manifest.json">
  <style>
    body { margin: 0; background: #080d1b; }
    #intro { position: fixed; inset: 0; display: grid; place-items: center; font: 700 54px system-ui; color: #eaf0ff; background: #080d1b; transition: opacity .45s; z-index: 999; }
    #intro span { border-bottom: 5px solid #53f5ff; animation: breathe 1.2s ease-in-out infinite alternate; }
    @keyframes breathe { to { opacity: .35; transform: translateY(-5px); } }
    @media (prefers-reduced-motion: reduce) { #intro span { animation: none; } }
  </style>
</head>
<body>
  <div id="intro" role="status" aria-label="Loading portfolio"><span>h.</span></div>
  <script>
    window.addEventListener('flutter-first-frame', function () {
      const intro = document.getElementById('intro');
      intro.style.opacity = '0';
      setTimeout(function () { intro.remove(); }, 450);
    });
  </script>
  <script src="flutter_bootstrap.js" async></script>
</body>
</html>
```


## web/favicon.svg

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64"><rect width="64" height="64" rx="14" fill="#53f5ff"/><text x="16" y="43" font-family="Arial,sans-serif" font-size="31" font-weight="bold" fill="#080d1b">h.</text></svg>
```


## web/manifest.json

```json
{"name":"Hardik Portfolio","short_name":"Portfolio","start_url":".","display":"standalone","background_color":"#080d1b","theme_color":"#53f5ff","description":"Developer and designer portfolio","icons":[{"src":"favicon.svg","sizes":"any","type":"image/svg+xml"}]}
```


## firebase.json

```json
﻿{"hosting":{"public":"build/web","ignore":["firebase.json","**/.*","**/node_modules/**"],"rewrites":[{"source":"**","destination":"/index.html"}]}}
```


## test/widget_test.dart

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/main.dart';
import 'package:portfolio/sections/contact_section.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  setUp(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });
  for (final width in [320.0, 375.0, 600.0, 768.0, 1024.0, 1440.0]) {
    testWidgets('Portfolio layout and navigation at $width', (tester) async {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const ProviderScope(child: PortfolioApp()));
      await tester.pump(const Duration(milliseconds: 700));
      expect(find.textContaining('Thoughtful code.'), findsOneWidget);
      expect(find.text("Hey, I'm Hardik."), findsOneWidget);
      expect(find.text('Flutter Developer | VR Automations'), findsOneWidget);
      expect(find.text('NovaStrike'), findsWidgets);
      expect(tester.takeException(), isNull);
      if (width < 1025) {
        await tester.tap(find.byTooltip('Open navigation'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));
        expect(find.text('Explore'), findsOneWidget);
        await tester.tap(find.text('Contact').last);
        await tester.pump();
      } else {
        await tester.tap(find.text('Contact').first);
        await tester.pump();
      }
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      expect(tester.takeException(), isNull);
      await tester.ensureVisible(
        find.descendant(
          of: find.byType(ContactSection),
          matching: find.text('Let\u2019s talk'),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      await tester.tap(
        find.descendant(
          of: find.byType(ContactSection),
          matching: find.text('Let\u2019s talk'),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Please enter your name.'), findsOneWidget);
      expect(find.text('Enter a valid email address.'), findsOneWidget);
      await tester.tap(find.byTooltip('Switch to light theme'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byTooltip('Switch to dark theme'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    });
  }
}
```

## lib/widgets/animated_logo.dart

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

## lib/widgets/rotating_role.dart

```dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../utils/portfolio_data.dart';

/// Keeps typewriter updates local to one text widget; pauses outside the viewport.
class RotatingRole extends StatefulWidget {
  const RotatingRole({super.key});
  @override
  State<RotatingRole> createState() => _RotatingRoleState();
}

class _RotatingRoleState extends State<RotatingRole> {
  Timer? timer;
  bool visible = false;
  bool reduced = false;
  bool deleting = false;
  int role = 0, count = 0, pause = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    reduced = MediaQuery.disableAnimationsOf(context);
    syncTimer();
  }

  void syncTimer() {
    if (!mounted) return;
    if (!visible || reduced) {
      timer?.cancel();
      timer = null;
    } else {
      timer ??= Timer.periodic(const Duration(milliseconds: 100), (_) {
        if (pause > 0) {
          pause--;
          return;
        }
        setState(() {
          if (deleting) {
            count--;
            if (count == 0) {
              deleting = false;
              role = (role + 1) % PortfolioData.roles.length;
              pause = 3;
            }
          } else {
            count++;
            if (count == PortfolioData.roles[role].length) {
              deleting = true;
              pause = 24;
            }
          }
        });
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => VisibilityDetector(
    key: ObjectKey(this),
    onVisibilityChanged: (info) {
      visible = info.visibleFraction > 0;
      syncTimer();
    },
    child: RepaintBoundary(
      child: Text(
        reduced
            ? PortfolioData.roles.first
            : '${PortfolioData.roles[role].substring(0, count)}│',
        style: TextStyle(
          fontSize: 17,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .6),
        ),
      ),
    ),
  );
}
```

## lib/widgets/skill_icon.dart

```dart
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
```

## lib/widgets/project_details.dart

```dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/project.dart';

class ProjectDetails extends StatelessWidget {
  final Project project;
  const ProjectDetails({super.key, required this.project});

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(project.title),
    content: SizedBox(
      width: 600,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              project.category,
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 1.2,
                color: Theme.of(context).hintColor,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              project.description,
              style: const TextStyle(fontSize: 15, height: 1.8),
            ),
            const SizedBox(height: 24),
            const Text(
              'What I built',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 14),
            ...project.highlights.map(
              (point) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Icon(
                        Icons.check_circle_outline,
                        size: 17,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        point,
                        style: const TextStyle(fontSize: 13, height: 1.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Technology',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: project.stack
                  .map(
                    (name) => Chip(
                      label: Text(name, style: const TextStyle(fontSize: 11)),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 18),
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: const Text(
                'Technical notes',
                style: TextStyle(fontSize: 14),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    project.details,
                    style: const TextStyle(fontSize: 13, height: 1.8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Close'),
      ),
      if (project.url.isNotEmpty)
        TextButton.icon(
          onPressed: () => launchUrl(
            Uri.parse(project.url),
            mode: LaunchMode.externalApplication,
            webOnlyWindowName: '_blank',
          ),
          icon: const Icon(Icons.north_east, size: 17),
          label: Text(project.linkLabel),
        ),
    ],
  );
}
```

## lib/providers/portfolio_providers.dart

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeModeProvider = NotifierProvider<ThemeController, ThemeMode>(
  ThemeController.new,
);

class ThemeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.dark;
  void toggle() =>
      state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
}

final caseStudyPageProvider =
    NotifierProvider.autoDispose<CaseStudyPageController, int>(
      CaseStudyPageController.new,
    );

class CaseStudyPageController extends Notifier<int> {
  @override
  int build() => 0;
  void select(int index) {
    if (state != index) state = index;
  }
}

@immutable
class NavigationState {
  final int activeSection;
  final bool scrolled;
  const NavigationState({this.activeSection = 0, this.scrolled = false});
}

final navigationProvider =
    NotifierProvider<NavigationController, NavigationState>(
      NavigationController.new,
    );

class NavigationController extends Notifier<NavigationState> {
  @override
  NavigationState build() => const NavigationState();
  void update({required int section, required bool scrolled}) {
    if (state.activeSection == section && state.scrolled == scrolled) return;
    state = NavigationState(activeSection: section, scrolled: scrolled);
  }
}

/// Riverpod owns resource lifetime. High-frequency updates remain paint/transform
/// listenables, so pointer and parallax changes do not rebuild provider consumers.
final viewportProvider = Provider.autoDispose<PortfolioViewport>((ref) {
  final viewport = PortfolioViewport();
  ref.onDispose(viewport.dispose);
  return viewport;
});

class PortfolioViewport {
  final controller = ScrollController();
  final parallax = ValueNotifier<double>(0);
  final cursor = ValueNotifier<Offset?>(null);
  void dispose() {
    controller.dispose();
    parallax.dispose();
    cursor.dispose();
  }
}

final contactSubmissionProvider =
    NotifierProvider.autoDispose<ContactSubmissionController, bool>(
      ContactSubmissionController.new,
    );

class ContactSubmissionController extends Notifier<bool> {
  @override
  bool build() => false;
  Future<void> submit(Future<void> Function() action) async {
    if (state) return;
    state = true;
    try {
      await action();
    } finally {
      if (ref.mounted) state = false;
    }
  }
}
```

## lib/widgets/portfolio_backdrop.dart

```dart
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
              light.color.withValues(alpha: dark ? .12 : .065),
              light.color.withValues(alpha: 0),
            ],
          ).createShader(Rect.fromCircle(center: light.point, radius: radius)),
      );
    }
    final paint = Paint()
      ..color = grid.withValues(alpha: dark ? .025 : .035)
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
```

## vercel.json

```json
{
  "$schema": "https://openapi.vercel.sh/vercel.json",
  "framework": null,
  "installCommand": "echo 'Flutter dependencies are installed by the build script.'",
  "buildCommand": "bash scripts/vercel-build.sh",
  "outputDirectory": "build/web",
  "routes": [
    { "handle": "filesystem" },
    { "src": "/.*", "dest": "/index.html" }
  ]
}
```

## scripts/vercel-build.sh

```bash
#!/usr/bin/env bash
set -euo pipefail

# Pin the SDK used to develop this app (Dart 3.12.2). Vercel's generic
# static-site build must provision Flutter before compiling Dart sources.
sdk_version="3.44.2"
sdk_commit="c9a6c484230f8b5e408ec57be1ef71dee1e77020"
sdk_dir="${PORTFOLIO_FLUTTER_SDK:-$PWD/.vercel/flutter-$sdk_version}"

if [[ ! -x "$sdk_dir/bin/flutter" ]]; then
  git clone --quiet --depth 1 --branch "$sdk_version" \
    https://github.com/flutter/flutter.git "$sdk_dir"
fi

if [[ "$(git -C "$sdk_dir" rev-parse HEAD)" != "$sdk_commit" ]]; then
  echo "Expected Flutter $sdk_version at commit $sdk_commit." >&2
  exit 1
fi

export PATH="$sdk_dir/bin:$PATH"
flutter config --no-analytics --enable-web
flutter --version
flutter pub get
flutter build web --release --no-web-resources-cdn --no-wasm-dry-run

# Prevent a successful deployment that has no compiled Flutter application.
test -s build/web/index.html
test -s build/web/flutter_bootstrap.js
test -s build/web/main.dart.js
```

## lib/widgets/project_preview_image.dart

```dart
import 'package:flutter/material.dart';
import '../models/project.dart';

/// Crops the rendered preview while preserving the original screenshot file.
class ProjectPreviewImage extends StatelessWidget {
  final Project project;
  final WidgetBuilder errorBuilder;
  const ProjectPreviewImage({
    super.key,
    required this.project,
    required this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      project.previewAsset!,
      fit: BoxFit.contain,
      semanticLabel: '${project.title} application screenshot',
      filterQuality: FilterQuality.medium,
      errorBuilder: (context, error, stackTrace) => errorBuilder(context),
    );
    if (project.previewTopCrop == 0 && project.previewBottomCrop == 0) {
      return image;
    }
    final visibleFraction =
        1 - project.previewTopCrop - project.previewBottomCrop;
    return AspectRatio(
      aspectRatio: project.previewSourceAspectRatio / visibleFraction,
      child: LayoutBuilder(
        builder: (context, box) {
          final fullHeight = box.maxWidth / project.previewSourceAspectRatio;
          return Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              Positioned(
                left: 0,
                top: -fullHeight * project.previewTopCrop,
                width: box.maxWidth,
                height: fullHeight,
                child: image,
              ),
            ],
          );
        },
      ),
    );
  }
}
```

## lib/sections/extended_sections.dart

```dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../utils/download.dart';
import '../utils/portfolio_data.dart';
import '../widgets/scroll_driven_case_studies.dart';
import '../widgets/shared.dart';
import '../widgets/skill_icon.dart';

class ExpertiseSection extends StatelessWidget {
  const ExpertiseSection({super.key});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SectionTitle(
        number: '02',
        label: 'WHAT I BUILD',
        title: 'Apps. Games.\nConnected experiences.',
      ),
      const SizedBox(height: 20),
      _muted(
        context,
        'Three areas where my application work and game engineering come together.',
      ),
      const SizedBox(height: 32),
      _TileGrid(
        maxColumns: 3,
        children: PortfolioData.capabilities
            .map(
              (item) => Container(
                padding: const EdgeInsets.all(26),
                decoration: AppTokens.glass(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: .08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SkillIcon(skill: item.icon),
                    ),
                    const SizedBox(height: 26),
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -.8,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _muted(context, item.description),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 7,
                      runSpacing: 8,
                      children: item.tools
                          .map((tool) => _tag(context, tool))
                          .toList(),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    ],
  );
}

class CaseStudiesSection extends StatelessWidget {
  const CaseStudiesSection({super.key});
  @override
  Widget build(BuildContext context) => const ScrollDrivenCaseStudies();
}

class _StoryPoint extends StatelessWidget {
  final String label, text;
  const _StoryPoint({required this.label, required this.text});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 9),
        _muted(context, text),
      ],
    ),
  );
}

class HighlightsSection extends StatelessWidget {
  const HighlightsSection({super.key});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SectionTitle(
        number: '07',
        label: 'ENGINEERING HIGHLIGHTS',
        title: 'Small details.\nSubstantial systems.',
      ),
      const SizedBox(height: 20),
      _muted(
        context,
        'Selected implementation details from my projects and résumé.',
      ),
      const SizedBox(height: 32),
      _TileGrid(
        maxColumns: 4,
        children: PortfolioData.engineeringHighlights
            .map(
              (item) => Container(
                padding: const EdgeInsets.all(24),
                decoration: AppTokens.glass(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.value,
                      style: TextStyle(
                        fontSize: 46,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -2,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item.label,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _muted(context, item.detail),
                    const SizedBox(height: 20),
                    _tag(context, item.project),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    ],
  );
}

class ResumeSection extends StatelessWidget {
  const ResumeSection({super.key});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SectionTitle(
        number: '08',
        label: 'TAKE A CLOSER LOOK',
        title: 'The full picture.\nReady to download.',
      ),
      const SizedBox(height: 32),
      Container(
        padding: const EdgeInsets.all(28),
        decoration: AppTokens.glass(context, radius: 20),
        child: LayoutBuilder(
          builder: (context, box) {
            final intro = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.description_outlined,
                  size: 46,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Hardik / Flutter Developer',
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -.8,
                  ),
                ),
                const SizedBox(height: 16),
                _muted(
                  context,
                  'A portable overview of my professional experience, application and game projects, technical skills, and education.',
                ),
                const SizedBox(height: 28),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    AnimatedButton(
                      label: 'View résumé',
                      icon: Icons.open_in_new,
                      onTap: () => launchUrl(
                        Uri.base.resolve(PortfolioData.cvFile),
                        webOnlyWindowName: '_blank',
                      ),
                    ),
                    AnimatedButton(
                      label: 'Download CV',
                      filled: false,
                      icon: Icons.download_outlined,
                      onTap: downloadCv,
                    ),
                  ],
                ),
              ],
            );
            final facts = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _StoryPoint(
                  label: 'PROFESSIONAL EXPERIENCE',
                  text:
                      'Flutter Developer at VR Automations and SGN Solutions.',
                ),
                const _StoryPoint(
                  label: 'SELECTED WORK',
                  text: 'Team Pulse / Blocktopus / NovaStrike',
                ),
                const _StoryPoint(
                  label: 'EDUCATION',
                  text:
                      'Master of Computer Applications and Bachelor of Computer Applications, Mullana.',
                ),
                _StoryPoint(
                  label: 'BASED IN',
                  text: '${PortfolioData.location}\n${PortfolioData.languages}',
                ),
              ],
            );
            return box.maxWidth < 760
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      intro,
                      const SizedBox(height: 36),
                      const Divider(),
                      const SizedBox(height: 24),
                      facts,
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 6, child: intro),
                      const SizedBox(width: 60),
                      Expanded(flex: 4, child: facts),
                    ],
                  );
          },
        ),
      ),
    ],
  );
}

class _TileGrid extends StatelessWidget {
  final int maxColumns;
  final List<Widget> children;
  const _TileGrid({required this.maxColumns, required this.children});
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      final count = (box.maxWidth / 260).floor().clamp(1, maxColumns);
      final width = (box.maxWidth - (count - 1) * 20) / count;
      return Wrap(
        spacing: 20,
        runSpacing: 20,
        children: List.generate(
          children.length,
          (i) => SizedBox(
            width: width,
            child: RevealOnScroll(delay: i * 70, child: children[i]),
          ),
        ),
      );
    },
  );
}

Widget _muted(BuildContext context, String text) => Text(
  text,
  style: TextStyle(
    fontSize: 14,
    height: 1.8,
    color: Theme.of(context).hintColor,
  ),
);

Widget _tag(BuildContext context, String text) => Container(
  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
  decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.primary.withValues(alpha: .07),
    borderRadius: BorderRadius.circular(6),
  ),
  child: Text(
    text,
    style: TextStyle(
      fontSize: 10,
      color: Theme.of(context).colorScheme.primary,
    ),
  ),
);
```

## lib/widgets/project_story_gallery.dart

```dart
import 'dart:ui' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/project.dart';
import '../providers/portfolio_providers.dart';
import '../theme/app_theme.dart';
import '../utils/portfolio_data.dart';
import 'project_preview_image.dart';
import 'shared.dart';

/// Snapping project rail, optionally driven by document scroll progress. Only the selected page is shared state;
/// hover and the scroll controller belong to this gallery's lifecycle.
class ProjectStoryGallery extends ConsumerStatefulWidget {
  final ValueListenable<double>? scrollProgress;
  final ValueChanged<int>? onPageRequested;
  final double? cardHeight;
  const ProjectStoryGallery({
    super.key,
    this.scrollProgress,
    this.onPageRequested,
    this.cardHeight,
  });
  @override
  ConsumerState<ProjectStoryGallery> createState() =>
      _ProjectStoryGalleryState();
}

class _ProjectStoryGalleryState extends ConsumerState<ProjectStoryGallery> {
  late final PageController controller;
  int requestedPage = 0;
  @override
  void initState() {
    super.initState();
    controller = PageController(
      initialPage: ref.read(caseStudyPageProvider),
      viewportFraction: .82,
    );
    requestedPage = ref.read(caseStudyPageProvider);
    widget.scrollProgress?.addListener(syncFromScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => syncFromScroll());
  }

  @override
  void didUpdateWidget(covariant ProjectStoryGallery oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scrollProgress != widget.scrollProgress) {
      oldWidget.scrollProgress?.removeListener(syncFromScroll);
      widget.scrollProgress?.addListener(syncFromScroll);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => syncFromScroll());
  }

  void syncFromScroll() {
    if (!mounted || widget.scrollProgress == null || !controller.hasClients) {
      return;
    }
    final target =
        (widget.scrollProgress!.value * (PortfolioData.projects.length - 1))
            .round();
    if (target == requestedPage) return;
    requestedPage = target;
    controller.animateToPage(
      target,
      duration: Duration(
        milliseconds: MediaQuery.disableAnimationsOf(context) ? 1 : 380,
      ),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    widget.scrollProgress?.removeListener(syncFromScroll);
    controller.dispose();
    super.dispose();
  }

  void moveTo(int page) {
    if (!controller.hasClients) return;
    if (widget.onPageRequested != null) {
      widget.onPageRequested!(page.clamp(0, PortfolioData.projects.length - 1));
      return;
    }
    controller.animateToPage(
      page.clamp(0, PortfolioData.projects.length - 1),
      duration: Duration(
        milliseconds: MediaQuery.disableAnimationsOf(context) ? 1 : 420,
      ),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final current = ref.watch(caseStudyPageProvider);
    final projects = PortfolioData.projects;
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.arrowRight): () =>
            moveTo(current + 1),
        const SingleActivator(LogicalKeyboardKey.arrowLeft): () =>
            moveTo(current - 1),
      },
      child: Focus(
        child: LayoutBuilder(
          builder: (context, box) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: widget.cardHeight ?? (box.maxWidth < 700 ? 560 : 540),
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse,
                      PointerDeviceKind.trackpad,
                      PointerDeviceKind.stylus,
                    },
                  ),
                  child: PageView.builder(
                    key: const ValueKey('project-story-rail'),
                    controller: controller,
                    padEnds: false,
                    physics: widget.scrollProgress != null
                        ? const NeverScrollableScrollPhysics()
                        : null,
                    allowImplicitScrolling: true,
                    onPageChanged: ref
                        .read(caseStudyPageProvider.notifier)
                        .select,
                    itemCount: projects.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: _StoryPoster(
                        project: projects[index],
                        index: index,
                        onOpen: () => showDialog<void>(
                          context: context,
                          builder: (_) =>
                              ProjectStoryDialog(project: projects[index]),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (widget.scrollProgress != null)
                ValueListenableBuilder<double>(
                  valueListenable: widget.scrollProgress!,
                  builder: (context, value, _) => LinearProgressIndicator(
                    value: value,
                    minHeight: 2,
                    backgroundColor: Theme.of(context).dividerColor,
                  ),
                )
              else
                LinearProgressIndicator(
                  value: (current + 1) / projects.length,
                  minHeight: 2,
                ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Semantics(
                    liveRegion: true,
                    child: Text(
                      '${(current + 1).toString().padLeft(2, '0')} / ${projects.length.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontSize: 12,
                        letterSpacing: 2,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  if (box.maxWidth >= 450)
                    ...List.generate(
                      projects.length,
                      (i) => Tooltip(
                        message: 'Show story ${i + 1}: ${projects[i].title}',
                        child: IconButton(
                          onPressed: () => moveTo(i),
                          icon: Icon(
                            Icons.circle,
                            size: i == current ? 9 : 6,
                            color: i == current
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(
                                    context,
                                  ).hintColor.withValues(alpha: .4),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 28,
                            minHeight: 44,
                          ),
                          padding: const EdgeInsets.all(6),
                        ),
                      ),
                    ),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Previous case study',
                    onPressed: current == 0 ? null : () => moveTo(current - 1),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  IconButton(
                    tooltip: 'Next case study',
                    onPressed: current == projects.length - 1
                        ? null
                        : () => moveTo(current + 1),
                    icon: const Icon(Icons.arrow_forward),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StoryPoster extends StatefulWidget {
  final Project project;
  final int index;
  final VoidCallback onOpen;
  const _StoryPoster({
    required this.project,
    required this.index,
    required this.onOpen,
  });
  @override
  State<_StoryPoster> createState() => _StoryPosterState();
}

class _StoryPosterState extends State<_StoryPoster> {
  bool hovered = false;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final project = widget.project;
    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        decoration: AppTokens.glass(context, radius: 22).copyWith(
          border: Border.all(
            color: colors.primary.withValues(alpha: hovered ? .65 : .24),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(22),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: widget.onOpen,
            child: LayoutBuilder(
              builder: (context, box) {
                final compact = box.maxHeight < 360;
                final padding = box.maxHeight < 250
                    ? 12.0
                    : box.maxWidth < 400
                    ? 20.0
                    : 28.0;
                final showTags = box.maxHeight >= 450;
                return Stack(
                  children: [
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              colors.tertiary.withValues(alpha: .3),
                              colors.primary.withValues(alpha: .12),
                              colors.surface,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 24,
                      right: -12,
                      width: box.maxWidth * .72,
                      height: box.maxHeight * .7,
                      child: IgnorePointer(
                        child: Opacity(
                          opacity: .22,
                          child: RepaintBoundary(
                            child: Center(
                              child: ProjectPreviewImage(
                                project: project,
                                errorBuilder: (_) => Icon(
                                  Icons.devices,
                                  size: 100,
                                  color: colors.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              colors.surface.withValues(alpha: .08),
                              colors.surface.withValues(alpha: .5),
                              colors.surface.withValues(alpha: .97),
                            ],
                            stops: const [0, .4, 1],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(padding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (box.maxHeight >= 280)
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'H / PROJECT STORY',
                                    style: TextStyle(
                                      fontSize: 10,
                                      letterSpacing: 2,
                                      color: colors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: colors.onSurface.withValues(
                                        alpha: .3,
                                      ),
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: const Text(
                                    'LIVE',
                                    style: TextStyle(fontSize: 9),
                                  ),
                                ),
                              ],
                            ),
                          const Spacer(),
                          Text(
                            project.category,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 9,
                              letterSpacing: 1.6,
                              color: colors.primary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            project.title,
                            maxLines: compact ? 1 : 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: box.maxWidth < 340 ? 28 : 42,
                              height: 1.05,
                              letterSpacing: -1.3,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (!compact) ...[
                            const SizedBox(height: 12),
                            Text(
                              project.description,
                              maxLines: box.maxHeight >= 450 ? 3 : 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.7,
                                color: colors.onSurface.withValues(alpha: .8),
                              ),
                            ),
                          ],
                          if (showTags) ...[
                            const SizedBox(height: 14),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: project.stack
                                  .take(3)
                                  .map(
                                    (name) => Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 9,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: colors.surface.withValues(
                                          alpha: .65,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        name,
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                          const SizedBox(height: 16),
                          AnimatedButton(
                            label: 'View story',
                            icon: Icons.arrow_forward,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: compact ? 10 : 14,
                            ),
                            onTap: widget.onOpen,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class ProjectStoryDialog extends StatelessWidget {
  final Project project;
  const ProjectStoryDialog({super.key, required this.project});
  @override
  Widget build(BuildContext context) {
    final story = PortfolioData.projectStories[project.title]!;
    final size = MediaQuery.sizeOf(context);
    return Dialog(
      insetPadding: EdgeInsets.all(size.width < 600 ? 16 : 40),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 960, maxHeight: size.height * .9),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      project.title,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close project story',
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: size.width < 600 ? 200 : 300,
                      width: double.infinity,
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: ProjectPreviewImage(
                            project: project,
                            errorBuilder: (_) =>
                                const Icon(Icons.devices, size: 60),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    _StoryParagraph(
                      title: 'The challenge',
                      text: story.challenge,
                    ),
                    _StoryParagraph(
                      title: 'The approach',
                      text: story.approach,
                    ),
                    _StoryParagraph(
                      title: 'Engineering details',
                      text: story.engineering,
                    ),
                    _StoryParagraph(title: 'The outcome', text: story.outcome),
                    const Text(
                      'Technology',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: project.stack
                          .map((name) => Chip(label: Text(name)))
                          .toList(),
                    ),
                    const SizedBox(height: 14),
                    ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      title: const Text('Implementation notes'),
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            project.details,
                            style: const TextStyle(fontSize: 14, height: 1.8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    AnimatedButton(
                      label: project.linkLabel,
                      onTap: () => launchUrl(
                        Uri.parse(project.url),
                        mode: LaunchMode.externalApplication,
                        webOnlyWindowName: '_blank',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryParagraph extends StatelessWidget {
  final String title, text;
  const _StoryParagraph({required this.title, required this.text});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            height: 1.8,
            color: Theme.of(context).hintColor,
          ),
        ),
      ],
    ),
  );
}
```

## lib/widgets/scroll_driven_case_studies.dart

```dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/portfolio_providers.dart';
import '../utils/portfolio_data.dart';
import 'project_story_gallery.dart';

/// A document-scroll pin, not a wheel interceptor. Native vertical gestures
/// advance the stories and naturally leave the section after the final project.
class ScrollDrivenCaseStudies extends ConsumerStatefulWidget {
  static const stickyTop = 96.0;
  const ScrollDrivenCaseStudies({super.key});
  @override
  ConsumerState<ScrollDrivenCaseStudies> createState() =>
      _ScrollDrivenCaseStudiesState();
}

class _ScrollDrivenCaseStudiesState
    extends ConsumerState<ScrollDrivenCaseStudies> {
  final anchor = GlobalKey();
  final pinOffset = ValueNotifier<double>(0);
  final progress = ValueNotifier<double>(0);
  late final ScrollController documentScroll;
  double travel = 0;

  @override
  void initState() {
    super.initState();
    documentScroll = ref.read(viewportProvider).controller;
    documentScroll.addListener(updateFromScroll);
  }

  void updateFromScroll() {
    if (!mounted || travel <= 0) return;
    final box = anchor.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final offset =
        (ScrollDrivenCaseStudies.stickyTop - box.localToGlobal(Offset.zero).dy)
            .clamp(0.0, travel);
    pinOffset.value = offset;
    progress.value = offset / travel;
  }

  void goToStory(int index) {
    final box = anchor.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !documentScroll.hasClients) return;
    final start =
        documentScroll.offset +
        box.localToGlobal(Offset.zero).dy -
        ScrollDrivenCaseStudies.stickyTop;
    final target = start + index / (PortfolioData.projects.length - 1) * travel;
    documentScroll.animateTo(
      target.clamp(0.0, documentScroll.position.maxScrollExtent),
      duration: Duration(
        milliseconds: MediaQuery.disableAnimationsOf(context) ? 1 : 650,
      ),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    documentScroll.removeListener(updateFromScroll);
    pinOffset.dispose();
    progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(viewportProvider);
    final viewport = MediaQuery.sizeOf(context);
    return LayoutBuilder(
      builder: (context, box) {
        final desktop = box.maxWidth >= 900;
        final panelHeight = (viewport.height - 112).clamp(300.0, 900.0);
        final introWidth = (box.maxWidth * .23).clamp(210.0, 270.0);
        final introHeight = viewport.height < 700 ? 64.0 : 96.0;
        final galleryWidth = desktop
            ? box.maxWidth - introWidth - 28
            : box.maxWidth;
        final cardHeight = desktop
            ? math
                  .min((galleryWidth * .82 - 16) / 1.48, panelHeight - 80)
                  .clamp(180.0, 560.0)
            : (panelHeight - introHeight - 12 - 80).clamp(140.0, 520.0);
        travel =
            (PortfolioData.projects.length - 1) *
            (panelHeight * .6).clamp(280.0, 520.0);
        WidgetsBinding.instance.addPostFrameCallback((_) => updateFromScroll());
        final intro = _GalleryIntro(
          compact: !desktop,
          showHint: desktop ? viewport.height >= 650 : viewport.height >= 700,
        );
        final gallery = ProjectStoryGallery(
          scrollProgress: progress,
          onPageRequested: goToStory,
          cardHeight: cardHeight,
        );
        return SizedBox(
          key: anchor,
          height: panelHeight + travel,
          child: Align(
            alignment: Alignment.topCenter,
            child: ValueListenableBuilder<double>(
              valueListenable: pinOffset,
              child: SizedBox(
                key: const ValueKey('pinned-case-study-panel'),
                height: panelHeight,
                child: desktop
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: introWidth, child: intro),
                          const SizedBox(width: 28),
                          Expanded(child: gallery),
                        ],
                      )
                    : Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: introHeight, child: intro),
                            const SizedBox(height: 12),
                            gallery,
                          ],
                        ),
                      ),
              ),
              builder: (context, value, child) =>
                  Transform.translate(offset: Offset(0, value), child: child),
            ),
          ),
        );
      },
    );
  }
}

class _GalleryIntro extends StatelessWidget {
  final bool compact, showHint;
  const _GalleryIntro({required this.compact, required this.showHint});
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '04 / PROJECT STORIES',
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 1.8,
            fontWeight: FontWeight.w600,
            color: colors.primary,
          ),
        ),
        SizedBox(height: compact ? 8 : 22),
        Text(
          compact ? 'Behind the screens.' : 'Behind\nthe screens.',
          maxLines: compact ? 1 : 3,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: compact ? 28 : 48,
            height: 1.05,
            letterSpacing: compact ? -1 : -2.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (showHint) ...[
          SizedBox(height: compact ? 8 : 24),
          Text(
            compact
                ? 'Swipe up to explore three project stories.'
                : 'Three projects, one at a time. Scroll down or swipe up to explore each story, then continue through the portfolio.',
            maxLines: compact ? 1 : 8,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: compact ? 12 : 14,
              height: 1.7,
              color: Theme.of(context).hintColor,
            ),
          ),
        ],
      ],
    );
  }
}
```
