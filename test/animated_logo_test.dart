import 'dart:ui' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/widgets/animated_logo.dart';
import 'package:portfolio/theme/app_theme.dart';
import 'package:portfolio/main.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  setUp(() {
    GoogleFonts.config.allowRuntimeFetching = false;
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });
  for (final width in [375.0, 1100.0, 1200.0, 1440.0]) {
    testWidgets('Logo expansion fits navbar at $width', (tester) async {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const ProviderScope(child: PortfolioApp()));
      await tester.pump(const Duration(seconds: 1));
      await tester.runAsync(() => GoogleFonts.pendingFonts());
      await tester.pump(const Duration(seconds: 1));
      final logo = find.byType(AnimatedLogo);
      final initialWidth = tester.getSize(logo).width;
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: Offset.zero);
      await mouse.moveTo(tester.getCenter(logo));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(
        tester.getSize(logo).width,
        width < 600 ? initialWidth : greaterThan(initialWidth),
      );
      expect(tester.takeException(), isNull);
      await mouse.removePointer();
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(seconds: 1));
    });
  }
  for (final dark in [false, true]) {
    for (final style in LogoStyle.values) {
      testWidgets('$style supports theme $dark, reduced motion and click', (
        tester,
      ) async {
        var clicked = false;
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTokens.theme(dark),
            home: MediaQuery(
              data: const MediaQueryData(
                size: Size(800, 600),
                disableAnimations: true,
              ),
              child: Scaffold(
                body: Center(
                  child: AnimatedLogo(
                    style: style,
                    onTap: () => clicked = true,
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pump();
        await tester.tap(find.byType(AnimatedLogo));
        expect(clicked, isTrue);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
      });
    }
  }
}
