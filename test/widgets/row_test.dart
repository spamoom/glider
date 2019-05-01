import 'package:cocoon/cocoon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('row test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Cocoon({
        "type": "row",
        "children": [
          {"type": "text", "text": "1"},
          {"type": "text", "text": "2"},
        ],
      }),
    ));

    expect(
      find.descendant(
        of: find.byType(Row),
        matching: find.text("1"),
      ),
      findsOneWidget,
    );

    expect(
      find.descendant(
        of: find.byType(Row),
        matching: find.text("2"),
      ),
      findsOneWidget,
    );
  });
}
