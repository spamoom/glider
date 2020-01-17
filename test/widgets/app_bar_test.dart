import 'package:glider/glider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app bar test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Glider({
        "type": "app_bar",
        "title": "Test",
      }),
    ));

    AppBar appBar = tester.widget(find.byType(AppBar));
    Text text = appBar.title;
    expect(text.data, equals("Test"));
  });
}
