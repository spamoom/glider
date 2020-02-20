# Building your first Glider

The first step is to create a new Flutter project, then replace the contents of `main.dart` with the following:

```dart
import 'package:glider/glider.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

String _myGliderDef = '''
{
    "type": "app",
    "title": "My First Glider",
    "theme": {
        "primary_color": "#2196F3",
        "accent_color": "#CDDC39",
        "dark": false,
    },
    "home": {
        "type": "scaffold",
        "app_bar": {
            "type": "app_bar",
            "title": "Hello"
        },
        "body": {
            "type": "center",
            "child": {
                "type": "text",
                "text": "Hello, world!"
            }
        }
    }
}
'''

void main() {
    runApp(_MyFirstGlider());
}

class _MyFirstGlider extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return Glider(jsonDecode(_myGliderDev));
    }
}
```

Run the app, and with any luck this should appear on your device or emulator:

<img src="hello_world_screen1.png" height="400">

Congratulations! You've built your first Glider.

**Next: [Widgets](widgets.md)**
