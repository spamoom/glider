import 'package:flutter/material.dart';
import 'package:glider/glider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('card test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Glider({
        "type": "card",
        "elevation": 2.0,
        "child": {
          "type": "text",
          "text": "Hello",
        }
      }),
    ));

    Card card = tester.widget(find.byType(Card));

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
