# Form Buttons

You can specify a number of Buttons which will be rendered at the bottom of the form.

Each button has a `type` and a `role`.

Currently supported `types` are:

* `text_button`
* `outline_button`
* `raised_button`

These are styled according to the corresponding Material Design specifications.

Supported `roles` are:

* `submit`, which submits the form according to the `form`'s `submit_to` property
* `back`, which navigates the app up one level if possible

```json
{
    "type": "text_button",
    "role": "submit",
    "text": "Save"
}
```

## See Also

* [Material Design - Buttons](https://material.io/design/components/buttons.html)
* [Forms](forms.md)
* [Form Fields](form_fields.md)