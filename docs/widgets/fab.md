# Floating Action Button

A Material Design Floating Action Button, which can display an icon and an optional label. Tapping the FAB will navigate to a different screen.

```json
{
    "type": "fab",
    "label": "New Alarm",
    "icon": "alarm",
    "destination": {
        "type": "scaffold"
    },
    "cloud_function": "my_function"
}
```

The `label` property is optional.

The `destination` property is required and must be a [`scaffold`](scaffold.md).

The `icon` property must be the name of a Material Design or FontAwesome icon.

The `cloud_function` property is optional, and must be the name of the Firebase Cloud Function to call when the button is pressed. The Cloud Function must be defined as a callable function in your app's Firebase project, as detailed [here](https://firebase.google.com/docs/functions/callable). After the function is successfully executed, if there is a `destination` property the app will navigate to that destination.

## See Also

* [Scaffold](scaffold.md)
* [Material Design - Floating Action Button](https://material.io/design/components/buttons-floating-action-button.html)