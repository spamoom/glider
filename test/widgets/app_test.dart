import 'package:glider/glider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app test', (WidgetTester tester) async {
    await tester.pumpWidget(const Glider(<String, dynamic>{
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

    final MaterialApp app = tester.widget(find.byType(MaterialApp));
    expect(app.title, equals("Test"));
    expect(app.theme.primaryColor, equals(Colors.white));
    expect(app.theme.accentColor, equals(Colors.black));
    expect(app.theme.brightness, equals(Brightness.light));
  });
}
