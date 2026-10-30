import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/sections/hero_section.dart';
import 'package:portfolio/widgets/rotating_role.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  testWidgets(
    'Hero preserves scene across typing/parallax and pauses offscreen',
    (tester) async {
      VisibilityDetectorController.instance.updateInterval = Duration.zero;
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final parallax = ValueNotifier<double>(0);
      final scroll = ScrollController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              controller: scroll,
              child: Column(
                children: [
                  HeroSection(
                    scroll: parallax,
                    viewWork: () {},
                    download: () {},
                  ),
                  const SizedBox(height: 2000),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pump();
      final orbit = find.byWidgetPredicate(
        (widget) => widget is CustomPaint && widget.painter is OrbitPainter,
      );
      final painter = tester.widget<CustomPaint>(orbit).painter as OrbitPainter;
      final role = find.descendant(
        of: find.byType(RotatingRole),
        matching: find.byType(Text),
      );
      final initialText = tester.widget<Text>(role).data;
      await tester.pump(const Duration(milliseconds: 500));
      expect(tester.widget<Text>(role).data, isNot(initialText));
      expect(
        identical(tester.widget<CustomPaint>(orbit).painter, painter),
        isTrue,
      );
      parallax.value = 80;
      await tester.pump();
      expect(
        identical(tester.widget<CustomPaint>(orbit).painter, painter),
        isTrue,
      );
      scroll.jumpTo(1300);
      await tester.pump();
      await tester.pump();
      VisibilityDetectorController.instance.notifyNow();
      await tester.pump(const Duration(milliseconds: 500));
      final pausedText = tester.widget<Text>(role).data;
      final pausedPhase = painter.motion.value;
      await tester.pump(const Duration(seconds: 2));
      expect(tester.widget<Text>(role).data, pausedText);
      expect(painter.motion.value, pausedPhase);
      scroll.jumpTo(0);
      await tester.pump();
      await tester.pump();
      VisibilityDetectorController.instance.notifyNow();
      await tester.pump(const Duration(milliseconds: 500));
      expect(tester.widget<Text>(role).data, isNot(pausedText));
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
      parallax.dispose();
      scroll.dispose();
    },
  );
}
