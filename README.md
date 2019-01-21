# Cocoon

Create a Flutter app based on a JSON API

## Supported Widgets

### App

This should be the root of the JSON tree.

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
        // A widget to use as the app's first page, probably a Scaffold.
    }
}
```

### Scaffold

```json
{
    "type": "scaffold",
    "app_bar": {
        // An app bar widget
    },
    "body": {
        // Any widget to be used as the page contents
    },
    "fab": {
        // A Floating Action Button
    },
    "drawer": {
        // A navigation drawer
    },
    "bottom_bar": {
        // A bottom navigation bar or bottom app bar
    },
    "bottom_sheet": {
        // A persistent bottom sheet
    }
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
    "aspect_ratio": 1.7, // Represents a 16:9 ratio
    "child": {
        // An arbitrary widget constrained by the aspect ratio
    }
}
```

### Button Bar

```json
{
    "type": "button_bar",
    "buttons": [
        // List of Button widgets
    ]
}
```

### Card

```json
{
    "type": "card",
    "child": {
        // An arbitrary widget
    },
    "elevation": 1.0
}
```

### Center

```json
{
    "type": "center",
    "child": {
        // An arbitrary widget
    }
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
    "children": [
        // A list of widgets
    ]
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
    "child": {
        // An arbitrary widget, probably a ListView
    }
}
```

### Floating Action Button

```json
{
    "type": "fab",
    "label": "New Alarm",
    "icon": "alarm", // The name of a Material or FontAwesome icon
    "destination": {
        // A Scaffold widget which will be navigated to when the FAB is clicked
    }
}
```

### Hero

```json
{
    "type": "hero",
    "tag": "a-tag",
    "child": {
        // A widget
    }
}
```

### Icon

```json
{
    "type": "icon",
    "icon": "person" // The name of a Material or FontAwesome icon
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
    "leading": {
        // A widget
    },
    "trailing": {
        // A widget
    },
    "destination": {
        // A Scaffold widget which will be navigated to when the ListTile is tapped
    }
}
```

### ListView

```json
{
    "type": "list_view",
    "children": [
        // A list of widgets
    ]
}
```

### Padding

```json
{
    "type": "padding",
    "padding": 16.0, // Sets padding for all sides
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

### Row

```json
{
    "type": "row",
    "children": [
        // A list of widgets
    ]
}
```

### Tooltip

```json
{
    "type": "tooltip",
    "child": {
        // The widget to wrap with the tooltip
    },
    "message": "A tooltip"
}
```