# The Scaffold Widget

A Scaffold widget should be used to wrap an app screen. It includes support for App Bars, Floating Action Buttons, Drawers, and Bottom Sheets.

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

All properties except `type` and `body` are optional.

All properties except `type` should be widgets of the relevant type.

**If you want to use a Bottom Navigation Bar, you should use a [Bottom Navigation Scaffold](bottom_nav.md) instead.**

## See Also

* [App Bar](app_bar.md)
* [Floating Action Button](fab.md)
* [Drawer](drawer.md)
* [Bottom Navigation Scaffold](bottom_nav.md)
* [Bottom Sheet](bottom_sheet.md)