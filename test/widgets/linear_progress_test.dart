import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:cocoon/cocoon.dart';

void main() {
  testWidgets('linear progress indicator test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Cocoon({
        "type": "linear_progress",
      }),
    ));

    expect(find.byType(LinearProgressIndicator), findsOneWidget);
  });
}
