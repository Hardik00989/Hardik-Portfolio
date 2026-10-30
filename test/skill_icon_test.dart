import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/widgets/skill_icon.dart';

class MissingAssets extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) =>
      Future.error(StateError('Simulated missing asset: $key'));
}

void main() {
  for (final skill in ['Flame Engine', 'FlutterFlow', 'Play Games Services']) {
    testWidgets('$skill stays compact if its image cannot load', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DefaultAssetBundle(
              bundle: MissingAssets(),
              child: Align(
                alignment: Alignment.topLeft,
                child: SkillIcon(skill: skill),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();
      expect(tester.getSize(find.byType(SkillIcon)), const Size(24, 24));
      expect(find.byType(Icon), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
