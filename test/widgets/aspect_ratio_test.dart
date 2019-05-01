import 'package:cocoon/cocoon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('aspect ratio test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Cocoon({
        "type": "aspect_ratio",
        "aspect_ratio": 1.7,
        "child": {
          "type": "text",
          "text": "Test",
        },
      }),
    ));

    AspectRatio aspectRatio = tester.widget(find.byType(AspectRatio));
    expect(aspectRatio.aspectRatio, equals(1.7));
  });
}
