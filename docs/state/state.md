# Widget State

By default, all Cocoon widgets are stateless.
You can add `state` to a widget and its children like this:

```json
{
    "type": "app",
    "title": "My Awesome App",
    "state": {
        "primary_color": "#FFFFFF",
        "dark": false
    },
    "theme": {
        "primary_color": {
            "type": "state_value",
            "key": "primary_color"
        },
        "accent_color": "#CDDC39",
        "dark": {
            "type": "state_value",
            "key": "dark"
        },
    },
    "home": {}
}
```