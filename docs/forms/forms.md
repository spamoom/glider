# Cocoon Forms

You can create a `form` widget like this:

```json
{
    "type": "form",
    "submit_to": {
        "url": "https://api.anapi.com/v1/posts",
        "method": "post|put|patch"
    },
    "fields": [],
    "buttons": []
}
```

The `submit_to` property should define the API endpoint to send form responses to. Responses will be sent as JSON objects.

The `fields` property should contain form fields, as defined [here](form_fields.md).

The `buttons` property should contain buttons, as defined [here](buttons.md).