import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glider/glider.dart';

void main() {
  testWidgets('circular progress indicator test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Glider(<String, dynamic>{
        "type": "circular_progress",
      }),
    ));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
