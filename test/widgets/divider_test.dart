import 'package:flutter/material.dart';
import 'package:glider/glider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('divider test (no indent)', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Glider(<String, dynamic>{
        "type": "divider",
      }),
    ));

    expect(find.byType(Divider), findsOneWidget);
  });

  testWidgets('divider test (with indent)', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Glider(<String, dynamic>{
        "type": "divider",
        "indent": 2.0,
      }),
    ));

    expect(find.byType(Divider), findsOneWidget);

    final Divider divider = tester.widget(find.byType(Divider));
    expect(divider.indent, equals(2.0));
  });
}
