import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:cocoon/cocoon.dart';

void main() {
  testWidgets('sized box test (childless)', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Cocoon({
        "type": "sized_box",
        "height": 16.0,
        "width": 8.0,
      }),
    ));

    expect(find.byType(SizedBox), findsOneWidget);
    SizedBox box = tester.widget(find.byType(SizedBox));
    expect(box.height, equals(16.0));
    expect(box.width, equals(8.0));
    expect(box.child, isNull);
  });

  testWidgets('sized box test (with child)', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Cocoon({
        "type": "sized_box",
        "height": 16.0,
        "width": 8.0,
        "child": {
          "type": "text",
          "text": "Hello",
        },
      }),
    ));

    expect(find.byType(SizedBox), findsOneWidget);
    SizedBox box = tester.widget(find.byType(SizedBox));
    expect(box.height, equals(16.0));
    expect(box.width, equals(8.0));
    expect(
      find.descendant(
        of: find.byType(SizedBox),
        matching: find.text("Hello"),
      ),
      findsOneWidget,
    );
  });
}
