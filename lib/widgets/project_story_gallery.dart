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
