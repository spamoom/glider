import 'package:glider/glider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('custom widget test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Glider(
          <String, dynamic>{
            "type": "my_custom_widget",
          },
          customWidgets: {
            "my_custom_widget": Text("Hello"),
          },
        ),
      ),
    );

    expect(find.text("Hello"), findsOneWidget);
  });
}
