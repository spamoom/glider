import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:glider/glider.dart';

void main() {
  testWidgets('center test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Glider({
        "type": "center",
        "child": {"type": "text", "text": "Hello"}
      }),
    ));

    expect(
      find.descendant(
        of: find.byType(Center),
        matching: find.text("Hello"),
      ),
      findsOneWidget,
    );
  });
}
