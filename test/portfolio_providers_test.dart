import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/providers/portfolio_providers.dart';
import 'package:portfolio/main.dart';
import 'package:portfolio/screens/portfolio_screen.dart';
import 'package:portfolio/sections/hero_section.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  test('Navbar selectors ignore unrelated section changes', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    var changes = 0;
    container.listen(
      navigationProvider.select((state) => state.scrolled),
      (_, _) => changes++,
    );
    final navigation = container.read(navigationProvider.notifier);
    navigation.update(section: 1, scrolled: true);
    navigation.update(section: 1, scrolled: true);
    navigation.update(section: 3, scrolled: true);
    expect(changes, 1);
    expect(container.read(navigationProvider).activeSection, 3);
    navigation.update(section: 0, scrolled: false);
    expect(changes, 2);
  });

  test(
    'Contact prevents duplicate work and resets after completion or failure',
    () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.listen(contactSubmissionProvider, (_, _) {});
      final controller = container.read(contactSubmissionProvider.notifier);
      final pending = Completer<void>();
      var calls = 0;
      final first = controller.submit(() {
        calls++;
        return pending.future;
      });
      await controller.submit(() async {
        calls++;
      });
      expect(calls, 1);
      expect(container.read(contactSubmissionProvider), isTrue);
      pending.complete();
      await first;
      expect(container.read(contactSubmissionProvider), isFalse);
      await expectLater(
        controller.submit(() async {
          throw StateError('launch failed');
        }),
        throwsStateError,
      );
      expect(container.read(contactSubmissionProvider), isFalse);
    },
  );

  test(
    'A pending contact operation can finish after provider disposal',
    () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final subscription = container.listen(
        contactSubmissionProvider,
        (_, _) {},
      );
      final pending = Completer<void>();
      final operation = container
          .read(contactSubmissionProvider.notifier)
          .submit(() => pending.future);
      subscription.close();
      await container.pump();
      pending.complete();
      await expectLater(operation, completes);
    },
  );

  testWidgets('Navigation changes preserve the hero widget and scene', (
    tester,
  ) async {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
    await tester.pumpWidget(const ProviderScope(child: PortfolioApp()));
    await tester.pump(const Duration(milliseconds: 700));
    final container = ProviderScope.containerOf(
      tester.element(find.byType(PortfolioScreen)),
    );
    final hero = tester.widget<HeroSection>(find.byType(HeroSection));
    container.read(viewportProvider).controller.jumpTo(200);
    await tester.pump();
    expect(container.read(navigationProvider).scrolled, isTrue);
    expect(
      identical(hero, tester.widget<HeroSection>(find.byType(HeroSection))),
      isTrue,
    );
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });
}
