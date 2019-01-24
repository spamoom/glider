import 'package:cocoon/cocoon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app bar test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Cocoon({
        "type": "app_bar",
        "title": "Test",
      }),
    ));

    AppBar appBar = tester.widget(find.byType(AppBar));
    Text text = appBar.title;
    expect(text.data, equals("Test"));
  });

  testWidgets('app test', (WidgetTester tester) async {
    await tester.pumpWidget(Cocoon({
      "type": "app",
      "title": "Test",
      "theme": {
        "primary_color": "#ffffff",
        "accent_color": "#000000",
        "dark": false,
      },
      "home": {
        "type": "app_bar",
        "title": "Hello",
      }
    }));

    MaterialApp app = tester.widget(find.byType(MaterialApp));
    expect(app.title, equals("Test"));
    expect(app.theme.primaryColor, equals(Colors.white));
    expect(app.theme.accentColor, equals(Colors.black));
    expect(app.theme.brightness, equals(Brightness.light));
  });

  testWidgets('aspect ratio test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Cocoon({
        "type": "aspect_ratio",
        "aspect_ratio": 1.7,
        "child": {
          "type": "text",
          "text": "Test",
        },
      }),
    ));

    AspectRatio aspectRatio = tester.widget(find.byType(AspectRatio));
    expect(aspectRatio.aspectRatio, equals(1.7));
  });

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
}
