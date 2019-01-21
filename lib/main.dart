import 'package:flutter/material.dart';
import 'dart:convert';
import 'cocoon.dart';

final String _testJson = '''
{
  "type": "app",
  "title": "Cocoon Test",
  "theme": {
    "primary_color": "#2196F3",
    "accent_color": "#CDDC39",
    "dark": true
  },
  "home": {
    "type": "scaffold",
    "app_bar": {
      "type": "app_bar",
      "title": "Cocoon"
    },
    "fab": {
      "type": "fab",
      "label": "New Alarm",
      "icon": "alarm",
      "destination": {
        "type": "scaffold",
        "app_bar": {
          "type": "app_bar",
          "title": "New Alarm"
        }
      }
    }
  }
}
''';

void main() {
  runApp(Cocoon.fromUrl("http://b7c570cb.ngrok.io/api/layouts/home"));
}
