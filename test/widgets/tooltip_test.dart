import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glider/glider.dart';

void main() {
  testWidgets('tooltip test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Glider(<String, dynamic>{
        "type": "tooltip",
        "message": "A tooltip",
        "child": {
          "type": "text",
          "text": "Hello",
        }
      }),
    ));

    expect(find.byTooltip("A tooltip"), findsOneWidget);
  });
}
