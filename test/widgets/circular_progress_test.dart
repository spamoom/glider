import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cocoon/cocoon.dart';

void main() {
  testWidgets('circular progress indicator test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Cocoon({
        "type": "circular_progress",
      }),
    ));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
