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
