# Bottom Navigation Scaffold

The `bottom_nav_scaffold` widget is a special version of [`scaffold`](scaffold.md) which provides support for the [Bottom Navigation Bar](https://material.io/design/components/bottom-navigation.html) from Material Design.

```json
{
    "type": "bottom_nav_scaffold",
    "app_bar": {},
    "fab": {},
    "drawer": {},
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

## See Also

* [Scaffold](scaffold.md)
* [App Bar](app_bar.md)
* [Floating Action Button](fab.md)
* [Drawer](drawer.md)