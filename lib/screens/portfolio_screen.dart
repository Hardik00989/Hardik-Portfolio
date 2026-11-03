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
  final keys = List.generate(9, (_) => GlobalKey());
  static const labels = [
    'Home',
    'About',
    'Expertise',
    'Work',
    'Case studies',
    'Skills',
    'Experience',
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
                            _section(7, const ResumeSection()),
                            _section(8, const ContactSection()),
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
                                  final index = [1, 3, 5, 6, 8][i];
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
                                  itemBuilder: (_) => [2, 4, 7]
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
                                  onTap: () => go(8),
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
