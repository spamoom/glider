# Text Button

A Material Design Text Button.

```json
{
    "type": "text_button",
    "text": "New Alarm",
    "destination": {
        "type": "scaffold"
    },
    "state_change": {
        "text": "Alarm created"
    }
}
```

One of `destination` and `state_change` is required.
The `destination` property must be a [`scaffold`](scaffold.md).
The `state_change` property must be a [`state_change`](../state/state_change.md)


## See Also

* [Scaffold](scaffold.md)
* [State Change](../state/state_change.md)
* [Material Design - Text Button](https://material.io/design/components/buttons.html#text-button)