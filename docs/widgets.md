# Widgets

Glider, like Flutter, is built around Widgets. A widget is represented by a JSON object, and every widget must have a `type` property so Glider knows what to display.

A very simple widget is the `text` widget:

```json
{
  "type": "text",
  "text": "Some text"
}
```

Widgets can be nested:

```json
{
  "type": "scaffold",
  "body": {
    "type": "center",
    "child": {
      "type": "text",
      "text": "Hello, world!"
    }
  },
  "app_bar": {
    "type": "app_bar",
    "title": "My Cool App"
  }
}
```

**Next: [App Widget](widgets/app.md)**
