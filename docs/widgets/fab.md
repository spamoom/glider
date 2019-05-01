# Floating Action Button

A Material Design Floating Action Button, which can display an icon and an optional label. Tapping the FAB will navigate to a different screen.

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

The `label` property is optional.

The `destination` property is required and must be a [`scaffold`](scaffold.md).

The `icon` property must be the name of a Material Design or FontAwesome icon.

## See Also

* [Scaffold](scaffold.md)
* [Material Design - Floating Action Button](https://material.io/design/components/buttons-floating-action-button.html)