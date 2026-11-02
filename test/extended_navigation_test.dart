import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/main.dart';
import 'package:portfolio/providers/portfolio_providers.dart';
import 'package:portfolio/screens/portfolio_screen.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  setUp(
    () => VisibilityDetectorController.instance.updateInterval = Duration.zero,
  );
  testWidgets('More menu reaches the resume section on desktop', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const ProviderScope(child: PortfolioApp()));
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.byTooltip('More sections'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.text('Resume').last);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    final container = ProviderScope.containerOf(
      tester.element(find.byType(PortfolioScreen)),
      listen: false,
    );
    expect(container.read(navigationProvider).activeSection, 8);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });

  testWidgets('All ten sections are reachable in a short mobile drawer', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(375, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const ProviderScope(child: PortfolioApp()));
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.byTooltip('Open navigation'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.ensureVisible(find.text('Contact').last);
    await tester.pump();
    await tester.tap(find.text('Contact').last);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    final container = ProviderScope.containerOf(
      tester.element(find.byType(PortfolioScreen)),
      listen: false,
    );
    expect(container.read(navigationProvider).activeSection, 9);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });
}
