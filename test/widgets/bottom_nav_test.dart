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
}
