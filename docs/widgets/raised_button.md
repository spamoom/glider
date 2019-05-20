# Raised Button

A Material Design Contained Button with text.

```json
{
    "type": "raised_button",
    "text": "New Alarm",
    "destination": {
        "type": "scaffold"
    },
    "state_change": {
        "text": "Alarm created"
    },
    "cloud_function": "my_function"
}
```

One of `destination` and `state_change` is required.
The `destination` property must be a [`scaffold`](scaffold.md).
The `state_change` property must be a [`state_change`](../state/state_change.md)

The `cloud_function` property is optional, and must be the name of the Firebase Cloud Function to call when the button is pressed. The Cloud Function must be defined as a callable function in your app's Firebase project, as detailed [here](https://firebase.google.com/docs/functions/callable). After the function is successfully executed, if there is a `destination` property the app will navigate to that destination.


## See Also

* [Scaffold](scaffold.md)
* [State Change](../state/state_change.md)
* [Material Design - Contained Button](https://material.io/design/components/buttons.html#contained-button)