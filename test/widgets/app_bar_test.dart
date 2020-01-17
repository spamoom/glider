import 'package:glider/glider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app bar test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Glider(<String, String>{
        "type": "app_bar",
        "title": "Test",
      }),
    ));

    final AppBar appBar = tester.widget(find.byType(AppBar));
    final Text text = appBar.title as Text;
    expect(text.data, equals("Test"));
  });
}
