import 'package:flutter/material.dart';
import 'package:glider/glider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('card test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Glider(<String, dynamic>{
        "type": "card",
        "elevation": 2.0,
        "child": {
          "type": "text",
          "text": "Hello",
        }
      }),
    ));

    final Card card = tester.widget(find.byType(Card));

    expect(card.elevation, equals(2.0));
    expect(
      find.descendant(
        of: find.byWidget(card),
        matching: find.text("Hello"),
      ),
      findsOneWidget,
    );
  });
}
