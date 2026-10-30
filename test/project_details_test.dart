import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/widgets/project_details.dart';
import 'package:portfolio/utils/portfolio_data.dart';
import 'package:portfolio/theme/app_theme.dart';

void main() {
  for (final width in [320.0, 1200.0]) {
    testWidgets('Project story is readable and dismissible at $width', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTokens.theme(false),
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) =>
                      ProjectDetails(project: PortfolioData.projects.first),
                ),
                child: const Text('Open project'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open project'));
      await tester.pumpAndSettle();
      expect(find.text('What I built'), findsOneWidget);
      expect(find.text('Technology'), findsOneWidget);
      expect(
        find.text(PortfolioData.projects.first.highlights.first),
        findsOneWidget,
      );
      await tester.ensureVisible(find.text('Technical notes'));
      await tester.tap(find.text('Technical notes'));
      await tester.pumpAndSettle();
      expect(find.text(PortfolioData.projects.first.details), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      expect(find.byType(ProjectDetails), findsNothing);
    });
  }
}
