# State Change

A State Change can be used along with a `button` to change values in the [`state`](state.md) of a widgets closest, [`state`](state.md) holding ancestor.
You can create a `state_change` like this:

```json
{
    "type": "raised_button",
    "text": "Enable dark mode",
    "state_change": {
        "primary_color": "#000000",
        "dark": true
    }
}
```

## See Also

* [Widget State](state.md)
* [Raised Button](../widgets/raised_button.md)
* [Text Button](../widgets/text_button.md)
* [Outline Button](../widgets/outline_button.md)
