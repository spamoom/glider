import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:glider/glider.dart';

void main() {
  testWidgets('test list tile (all properties)', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Glider(<String, dynamic>{
        "type": "scaffold",
        "body": {
          "type": "list_tile",
          "title": "John Smith",
          "subtitle": "john@smith.com",
          "leading": {
            "type": "icon",
            "icon": "person",
          },
          "trailing": {
            "type": "icon",
            "icon": "delete",
          },
          "destination": {
            "type": "scaffold",
            "app_bar": {
              "type": "app_bar",
              "title": "Destination",
            }
          }
        }
      }),
    ));

    expect(find.byType(ListTile), findsOneWidget);
    final ListTile tile = tester.widget(find.byType(ListTile));
    final Text title = tile.title as Text;
    final Text subtitle = tile.subtitle as Text;
    final Widget leading = tile.leading;
    final Widget trailing = tile.trailing;
    expect(title.data, equals("John Smith"));
    expect(subtitle.data, equals("john@smith.com"));
    expect(
      find.descendant(
        of: find.byWidget(leading),
        matching: find.byIcon(Icons.person),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byWidget(trailing),
        matching: find.byIcon(Icons.delete),
      ),
      findsOneWidget,
    );

    await tester.tap(find.byWidget(tile));
    await tester.pumpAndSettle();

    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text("Destination"), findsOneWidget);
  });

  testWidgets('test list tile (only title and destination)',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Glider(<String, dynamic>{
        "type": "scaffold",
        "body": {
          "type": "list_tile",
          "title": "John Smith",
          "destination": {
            "type": "scaffold",
            "app_bar": {
              "type": "app_bar",
              "title": "Destination",
            }
          }
        }
      }),
    ));

    expect(find.byType(ListTile), findsOneWidget);
    final ListTile tile = tester.widget(find.byType(ListTile));
    final Text title = tile.title as Text;
    expect(title.data, "John Smith");

    await tester.tap(find.byWidget(tile));
    await tester.pumpAndSettle();

    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text("Destination"), findsOneWidget);
  });
}
