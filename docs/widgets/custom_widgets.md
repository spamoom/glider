# Custom Widgets

Glider allows you to specify a set of custom Flutter widgets, which you can then include in your Glider definition.

Using this JSON:

```json
{
  "type": "my_custom_widget"
}
```

Simply include the `_customWidgets` parameter in `Glider`'s constructor:

```dart
Glider(myJson, customWidgets: {
    "my_custom_widget": Text("Hello"),
});
```

The resulting app will now render a Text widget wherever it sees `"type": "my_custom_widget` in the Glider definition. Neat!
