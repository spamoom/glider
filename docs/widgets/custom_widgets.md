# Custom Widgets

Cocoon allows you to specify a set of custom Flutter widgets, which you can then include in your Cocoon definition.

Using this JSON:

```json
{
    "type": "my_custom_widget",
}
```

Simply include the `_customWidgets` parameter in `Cocoon`'s constructor:

```dart
Cocoon(myJson, customWidgets: {
    "my_custom_widget": Text("Hello"),
});
```

The resulting app will now render a Text widget wherever it sees `"type": "my_custom_widget` in the Cocoon definition. Neat!