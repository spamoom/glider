import 'package:glider/glider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('scaffold app bar test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Glider({
        "type": "scaffold",
        "app_bar": {
          "type": "app_bar",
          "title": "App Bar",
        },
      }),
    ));

    AppBar appBar = tester.widget(find.byType(AppBar));
    Text title = appBar.title;
    expect(title.data, "App Bar");
  });

  testWidgets('scaffold fab test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Glider({
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

    FloatingActionButton fab = tester.widget(find.byType(FloatingActionButton));
    expect(fab.isExtended, isTrue);
    Icon icon = tester.widget(find.descendant(
      of: find.byWidget(fab),
      matching: find.byIcon(Icons.alarm),
    ));
    expect(icon.icon, equals(Icons.alarm));
    Text text = tester.widget(find.descendant(
      of: find.byWidget(fab),
      matching: find.text("New Alarm"),
    ));
    expect(text.data, equals("New Alarm"));
  });

  testWidgets('scaffold drawer test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Glider({
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
