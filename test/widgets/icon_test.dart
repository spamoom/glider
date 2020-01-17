import 'package:flutter/material.dart';
import 'package:glider/glider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  testWidgets('icon test (Material)', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Glider({
        "type": "icon",
        "icon": "person",
      }),
    ));

    expect(find.byType(Icon), findsOneWidget);

    Icon icon = tester.widget(find.byType(Icon));
    expect(icon.icon, equals(Icons.person));
  });

  testWidgets('icon test (FontAwesome)', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Glider({
        "type": "icon",
        "icon": "applePay",
      }),
    ));

    expect(find.byType(Icon), findsOneWidget);

    Icon icon = tester.widget(find.byType(Icon));
    expect(icon.icon, equals(FontAwesomeIcons.applePay));
  });
}
