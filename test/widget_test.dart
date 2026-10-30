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
