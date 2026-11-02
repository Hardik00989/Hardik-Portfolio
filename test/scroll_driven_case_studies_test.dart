import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/providers/portfolio_providers.dart';
import 'package:portfolio/theme/app_theme.dart';
import 'package:portfolio/widgets/scroll_driven_case_studies.dart';

void main() {
  for (final size in [const Size(1440, 900), const Size(375, 600)]) {
    testWidgets('Vertical input pins, advances and releases stories at $size', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTokens.theme(true),
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, _) => SingleChildScrollView(
                  controller: ref.watch(viewportProvider).controller,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: const Column(
                    children: [
                      SizedBox(height: 180),
                      ScrollDrivenCaseStudies(),
                      SizedBox(height: 1200),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      final section = find.byType(ScrollDrivenCaseStudies);
      final panel = find.byKey(const ValueKey('pinned-case-study-panel'));
      final container = ProviderScope.containerOf(
        tester.element(section),
        listen: false,
      );
      final scroll = container.read(viewportProvider).controller;
      final start =
          tester.getTopLeft(section).dy - ScrollDrivenCaseStudies.stickyTop;
      final travel =
          tester.getSize(section).height - tester.getSize(panel).height;
      scroll.jumpTo(start);
      await tester.pump();
      expect(
        tester.getTopLeft(panel).dy,
        closeTo(ScrollDrivenCaseStudies.stickyTop, .01),
      );
      if (size.width > 600) {
        await tester.sendEventToBinding(
          PointerScrollEvent(
            position: tester.getCenter(panel),
            scrollDelta: Offset(0, travel * .35),
          ),
        );
      } else {
        await tester.timedDrag(
          panel,
          Offset(0, -travel * .35),
          const Duration(seconds: 1),
        );
      }
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(container.read(caseStudyPageProvider), 1);
      expect(
        tester.getTopLeft(panel).dy,
        closeTo(ScrollDrivenCaseStudies.stickyTop, .01),
      );
      scroll.jumpTo(start + travel);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(container.read(caseStudyPageProvider), 2);
      expect(
        tester.getTopLeft(panel).dy,
        closeTo(ScrollDrivenCaseStudies.stickyTop, .01),
      );
      scroll.jumpTo(start + travel + 120);
      await tester.pump();
      expect(
        tester.getTopLeft(panel).dy,
        closeTo(ScrollDrivenCaseStudies.stickyTop - 120, .01),
      );
      scroll.jumpTo(start);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(container.read(caseStudyPageProvider), 0);
      await tester.tap(find.byTooltip('Next case study'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      expect(container.read(caseStudyPageProvider), 1);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    });
  }
}
