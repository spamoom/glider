import 'package:cocoon/cocoon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('column test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Cocoon({
        "type": "column",
        "children": [
          {"type": "text", "text": "1"},
          {"type": "text", "text": "2"},
        ],
      }),
    ));

    expect(
      find.descendant(
        of: find.byType(Column),
        matching: find.text("1"),
      ),
      findsOneWidget,
    );

    expect(
      find.descendant(
        of: find.byType(Column),
        matching: find.text("2"),
      ),
      findsOneWidget,
    );
  });
}
