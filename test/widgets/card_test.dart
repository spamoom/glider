import 'package:flutter/material.dart';
import 'package:cocoon/cocoon.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('card test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Cocoon({
        "type": "card",
        "elevation": 1.0,
        "child": {
          "type": "text",
          "text": "Hello",
        }
      }),
    ));

    Card card = tester.widget(find.byType(Card));

    expect(card.elevation, equals(1.0));
    expect(
      find.descendant(
        of: find.byWidget(card),
        matching: find.text("Hello"),
      ),
      findsOneWidget,
    );
  });
}
