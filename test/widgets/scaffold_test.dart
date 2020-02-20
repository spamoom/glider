import 'package:glider/glider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('scaffold app bar test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Glider(<String, dynamic>{
        "type": "scaffold",
        "app_bar": {
          "type": "app_bar",
          "title": "App Bar",
        },
      }),
    ));

    final AppBar appBar = tester.widget(find.byType(AppBar));
    final Text title = appBar.title as Text;
    expect(title.data, "App Bar");
  });

  testWidgets('scaffold fab test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Glider(<String, dynamic>{
        "type": "scaffold",
        "fab": {
          "type": "fab",
          "icon": "alarm",
          "label": "New Alarm",
          "destination": {
            "type": "scaffold",
          }
        },
      }),
    ));

    final FloatingActionButton fab =
        tester.widget(find.byType(FloatingActionButton));
    expect(fab.isExtended, isTrue);
    final Icon icon = tester.widget(find.descendant(
      of: find.byWidget(fab),
      matching: find.byIcon(Icons.alarm),
    ));
    expect(icon.icon, equals(Icons.alarm));
    final Text text = tester.widget(find.descendant(
      of: find.byWidget(fab),
      matching: find.text("New Alarm"),
    ));
    expect(text.data, equals("New Alarm"));
  });

  testWidgets('scaffold drawer test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Glider(<String, dynamic>{
        "type": "scaffold",
        "app_bar": {
          "type": "app_bar",
          "title": "App Bar",
        },
        "drawer": {
          "type": "drawer",
          "child": {
            "type": "text",
            "text": "Drawer",
          }
        },
      }),
    ));

    expect(find.text("Drawer"), findsNothing);
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    expect(find.text("Drawer"), findsOneWidget);
  });
}
