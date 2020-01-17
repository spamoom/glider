import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:glider/glider.dart';

void main() {
  testWidgets('linear progress indicator test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Glider({
        "type": "linear_progress",
      }),
    ));

    expect(find.byType(LinearProgressIndicator), findsOneWidget);
  });
}
