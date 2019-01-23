# The App Widget

The App widget should be the highest-level widget in your app i.e. the thing you pass into `Cocoon`'s constructor should be an App widget.

```json
{
    "type": "app",
    "title": "My Awesome App",
    "theme": {
        "primary_color": "#2196F3",
        "accent_color": "#CDDC39",
        "dark": false,
    },
    "home": {}
}
```

All properties are required. The `home` property should be a Widget, and you probably want to use a [`scaffold`](scaffold.md).

## See Also

* [Scaffold](scaffold.md)
* [Theme](theme.md)