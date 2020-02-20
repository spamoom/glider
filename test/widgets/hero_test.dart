import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:glider/glider.dart';

void main() {
  testWidgets('hero test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Glider(<String, dynamic>{
        "type": "hero",
        "tag": "a-tag",
        "child": {
          "type": "icon",
          "icon": "person",
        }
      }),
    ));

    expect(find.byType(Hero), findsOneWidget);
    expect(find.byType(Icon), findsOneWidget);

    final Hero hero = tester.widget(find.byType(Hero));
    expect(hero.tag, equals("a-tag"));
  });
}
