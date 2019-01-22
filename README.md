# Cocoon

Create a Flutter app based on a JSON API

## Installation

To get started with Cocoon add the following to your pubspec.yaml file

```yaml
cocoon:
    git:
        url: git://github.com/netsells/cocoon.git
```

Replace your main.dart file with the following:

```dart
import 'package:cocoon/cocoon.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(CocoonApp());
}

class CocoonApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return Cocoon.fromUrl("{YOUR_COCOON_API_URL}",
        fallback: "{YOUR_FALLBACK_JSON}");
  }
}
```

Initialising your app this way means that you can take advantage of hot reloading.

### Fallback JSON

Should the user open your app offline or the network request fails, you can pass in fallback JSON which could be an API response
which has been stored and bundled with the app.

## Supported Widgets

### App

This should be the root of the application.

```json
{
    "type": "app",
    "title": "My Cocoon",
    "theme": {
        "primary_color": "#FFFFFF",
        "accent_color": "#000000",
        "dark": false
    },
    "debug": false,
    "home": {
        "type": "scaffold"
    }
}
```

### Scaffold

```json
{
    "type": "scaffold",
    "app_bar": {},
    "body": {},
    "fab": {},
    "drawer": {},
    "bottom_bar": {},
    "bottom_sheet": {}
}
```

### Bottom Navigation Scaffold

```json
{
    "type": "bottom_nav_scaffold",
    "app_bar": {},
    "fab": {},
    "items": [
      {
        "icon": "alarm",
        "title": "Alarms",
        "body": {
          "type": "center",
          "child": {
            "type": "text",
            "text": "Alarms"
          }
        }
      },
      {
        "icon": "person",
        "title": "Profile",
        "body": {
          "type": "center",
          "child": {
            "type": "text",
            "text": "Profile"
          }
        }
      }
    ]
}
```

### App Bar

```json
{
    "type": "app_bar",
    "title": "Cocoon"
}
```

### Aspect Ratio

```json
{
    "type": "aspect_ratio",
    "aspect_ratio": 1.7,
    "child": {}
}
```

### Button Bar

```json
{
    "type": "button_bar",
    "buttons": []
}
```

### Card

```json
{
    "type": "card",
    "child": {},
    "elevation": 1.0
}
```

### Center

```json
{
    "type": "center",
    "child": {}
}
```

### Circular Progress Indicator

```json
{
    "type": "circular_progress"
}
```

### Column

```json
{
    "type": "column",
    "children": []
}
```

### Divider

```json
{
    "type": "divider"
}
```

### Drawer

```json
{
    "type": "drawer",
    "child": {}
}
```

### Floating Action Button

```json
{
    "type": "fab",
    "label": "New Alarm",
    "icon": "alarm",
    "destination": {
        "type": "scaffold"
    }
}
```

### Hero

```json
{
    "type": "hero",
    "tag": "a-tag",
    "child": {}
}
```

### Icon

```json
{
    "type": "icon",
    "icon": "person"
}
```

### Image

```json
{
    "type": "image",
    "src": "https://athing.com/thing.jpg",
}
```

### Linear Progress Indicator

```json
{
    "type": "linear_progress"
}
```

### List Tile

```json
{
    "type": "list_tile",
    "title": "John Smith",
    "subtitle": "john@smith.com",
    "leading": {},
    "trailing": {},
    "destination": {
        "type": "scaffold"
    }
}
```

### ListView

```json
{
    "type": "list_view",
    "children": []
}
```

### Padding

```json
{
    "type": "padding",
    "padding": 16.0,
    "padding_vertical": 8.0,
    "padding_horizontal": 4.0,
    "padding_left": 4.0,
    "padding_right": 4.0,
    "padding_top": 4.0,
    "padding_bottom": 4.0
}
```

You must specify either:

* `padding`
* `padding_vertical` and `padding_horizontal`
* `padding_left`, `padding_right`, `padding_top`, and `padding_bottom`

### Sized Box

```json
{
    "type": "sized_box",
    "height": 16.0,
    "width": null,
    "child": {}
}
```

### Row

```json
{
    "type": "row",
    "children": []
}
```

### Text

```json
{
    "type": "text",
    "text": "Hello"
}
```

### Tooltip

```json
{
    "type": "tooltip",
    "child": {},
    "message": "A tooltip"
}
```

### URL

Gets a widget definition from the specified URL. Designed for use with Scaffolds.

```json
{
    "type": "url",
    "url": "https://athing.com/thing.json"
}
```