import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:glider/glider.dart';

void main() {
  testWidgets('padding test (same on all sides)', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Glider({
        "type": "padding",
        "padding": 16.0,
        "child": {
          "type": "circular_progress",
        }
      }),
    ));

    expect(find.byType(Padding), findsOneWidget);
    Padding padding = tester.widget(find.byType(Padding));
    expect(padding.padding, equals(EdgeInsets.all(16.0)));
  });

  testWidgets('padding test (horizontal and vertical)',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Glider({
        "type": "padding",
        "padding_horizontal": 16.0,
        "padding_vertical": 8.0,
        "child": {
          "type": "circular_progress",
        }
      }),
    ));

    expect(find.byType(Padding), findsOneWidget);
    Padding padding = tester.widget(find.byType(Padding));
    expect(
      padding.padding,
      equals(EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 16.0,
      )),
    );
  });

  testWidgets('padding test (all different)', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Glider({
        "type": "padding",
        "padding_left": 4.0,
        "padding_right": 8.0,
        "padding_top": 12.0,
        "padding_bottom": 16.0,
        "child": {
          "type": "circular_progress",
        }
      }),
    ));

    expect(find.byType(Padding), findsOneWidget);
    Padding padding = tester.widget(find.byType(Padding));
    expect(
      padding.padding,
      equals(EdgeInsets.fromLTRB(4.0, 12.0, 8.0, 16.0)),
    );
  });
}
