import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/portfolio_providers.dart';
import '../utils/portfolio_data.dart';
import '../theme/app_theme.dart';
import 'project_story_gallery.dart';

/// A document-scroll pin, not a wheel interceptor. Native vertical gestures
/// advance the stories and naturally leave the section after the final project.
class ScrollDrivenCaseStudies extends ConsumerStatefulWidget {
  static const stickyTop = AppTokens.navbarHeight + 16;
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
