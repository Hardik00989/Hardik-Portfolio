import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/providers/portfolio_providers.dart';
import 'package:portfolio/theme/app_theme.dart';
import 'package:portfolio/utils/portfolio_data.dart';
import 'package:portfolio/widgets/project_story_gallery.dart';
import 'package:portfolio/widgets/shared.dart';

void main() {
  for (final width in [375.0, 1440.0]) {
    testWidgets('Project rail navigates, swipes and opens a story at $width', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTokens.theme(true),
            home: const Scaffold(
              body: SingleChildScrollView(
                padding: EdgeInsets.all(24),
                child: ProjectStoryGallery(),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      final container = ProviderScope.containerOf(
        tester.element(find.byType(ProjectStoryGallery)),
        listen: false,
      );
      expect(
        tester
            .widget<IconButton>(
              find.byWidgetPredicate(
                (w) => w is IconButton && w.tooltip == 'Previous case study',
              ),
            )
            .onPressed,
        isNull,
      );
      await tester.tap(
        find.byWidgetPredicate(
          (w) => w is IconButton && w.tooltip == 'Next case study',
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(container.read(caseStudyPageProvider), 1);
      expect(find.text('02 / 03'), findsOneWidget);
      await tester.drag(
        find.byKey(const ValueKey('project-story-rail')),
        Offset(-width * .8, 0),
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(container.read(caseStudyPageProvider), 2);
      expect(
        tester
            .widget<IconButton>(
              find.byWidgetPredicate(
                (w) => w is IconButton && w.tooltip == 'Next case study',
              ),
            )
            .onPressed,
        isNull,
      );
      await tester.tap(
        find.widgetWithText(AnimatedButton, 'View story').hitTestable().last,
      );
      await tester.pumpAndSettle();
      expect(find.byType(ProjectStoryDialog), findsOneWidget);
      expect(find.text('The challenge'), findsOneWidget);
      expect(
        find.text(PortfolioData.projectStories['NovaStrike']!.engineering),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
      await tester.tap(find.byTooltip('Close project story'));
      await tester.pumpAndSettle();
      expect(find.byType(ProjectStoryDialog), findsNothing);
      expect(container.read(caseStudyPageProvider), 2);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    });
  }
}
