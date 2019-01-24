import 'package:cocoon/cocoon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('bottom navigation tab switching test',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Cocoon({
        "type": "bottom_nav_scaffold",
        "items": [
          {
            "icon": "alarm",
            "title": "Alarms",
            "body": {
              "type": "center",
              "child": {"type": "text", "text": "Alarms Page!"}
            }
          },
          {
            "icon": "person",
            "title": "Profile",
            "body": {
              "type": "center",
              "child": {"type": "text", "text": "Profile Page!"}
            }
          },
        ],
      }),
    ));

    // The first page should be the Alarms page
    expect(
      (tester.widget(find.descendant(
        of: find.byType(Center),
        matching: find.text("Alarms Page!"),
      )) as Text)
          .data,
      equals("Alarms Page!"),
    );

    // Tap the "Profile" tab
    await tester.tap(find.text("Profile"));
    await tester.pumpAndSettle();

    // The Profile page should now be visible
    expect(
      (tester.widget(find.descendant(
        of: find.byType(Center),
        matching: find.text("Profile Page!"),
      )) as Text)
          .data,
      equals("Profile Page!"),
    );

    // Tap the Alarms tab
    await tester.tap(find.text("Alarms"));
    await tester.pumpAndSettle();

    // The Alarms page should now be visible again
    expect(
      (tester.widget(find.descendant(
        of: find.byType(Center),
        matching: find.text("Alarms Page!"),
      )) as Text)
          .data,
      equals("Alarms Page!"),
    );
  });

  testWidgets('bottom navigation scaffold app bar test',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Cocoon({
        "type": "bottom_nav_scaffold",
        "app_bar": {
          "type": "app_bar",
          "title": "App Bar",
        },
        "items": [
          {
            "icon": "alarm",
            "title": "Alarms",
            "body": {
              "type": "center",
              "child": {"type": "text", "text": "Alarms"}
            }
          },
          {
            "icon": "person",
            "title": "Profile",
            "body": {
              "type": "center",
              "child": {"type": "text", "text": "Profile"}
            }
          }
        ],
      }),
    ));

    AppBar appBar = tester.widget(find.byType(AppBar));
    Text title = appBar.title;
    expect(title.data, "App Bar");
  });

  testWidgets('bottom navigation scaffold fab test',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Cocoon({
        "type": "bottom_nav_scaffold",
        "fab": {
          "type": "fab",
          "icon": "alarm",
          "label": "New Alarm",
          "destination": {
            "type": "scaffold",
          }
        },
        "items": [
          {
            "icon": "alarm",
            "title": "Alarms",
            "body": {
              "type": "center",
              "child": {"type": "text", "text": "Alarms"}
            }
          },
          {
            "icon": "person",
            "title": "Profile",
            "body": {
              "type": "center",
              "child": {"type": "text", "text": "Profile"}
            }
          }
        ]
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

  testWidgets('bottom navigation scaffold drawer test',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Cocoon({
        "type": "bottom_nav_scaffold",
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
        "items": [
          {
            "icon": "alarm",
            "title": "Alarms",
            "body": {
              "type": "center",
              "child": {"type": "text", "text": "Alarms"}
            }
          },
          {
            "icon": "person",
            "title": "Profile",
            "body": {
              "type": "center",
              "child": {"type": "text", "text": "Profile"}
            }
          }
        ]
      }),
    ));

    expect(find.text("Drawer"), findsNothing);
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    expect(find.text("Drawer"), findsOneWidget);
  });
}
