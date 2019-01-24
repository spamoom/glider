# Supported Form Fields

All field widgets must have a type and a name (which will be the property name in the resulting JSON object).

## Text Fields

```json
{
    "type": "text_field",
    "name": "first_name",
    "label": "First Name",
    "capitalization": "words|sentences|characters",
    "hint": "e.g. John",
    "help": "Your first name",
    "keyboard_type": "text|email|phone|number",
    "required": true
}
```

## Checkbox

```json
{
    "type": "checkbox",
    "name": "terms",
    "icon": "person",
    "title": "Terms & Conditions",
    "subtitle": "Do you agree to our Terms?",
    "initial_value": false,
    "required": true
}
```

## Switch

```json
{
    "type": "switch",
    "name": "pro",
    "icon": null,
    "title": "Pro Features",
    "subtitle": null,
    "initial_value": false
}
```

## Radio Group

```json
{
    "type": "radio_group",
    "name": "sex",
    "label": "Sex",
    "initial_value": "female",
    "options": [
    {
        "value": "male",
        "title": "Male",
        "subtitle": null,
        "icon": null
    },
    {
        "value": "female",
        "title": "Female",
        "subtitle": null,
        "icon": null
    },
    {
        "value": "other",
        "title": "Other/Prefer not to say",
        "subtitle": null,
        "icon": null
    }
    ]
}
```

## Dropdown Menu (Spinner)

```json
{
    "type": "dropdown_menu",
    "name": "sex",
    "label": "Sex",
    "initial_value": "female",
    "options": [
    {"value": "male", "text": "Male"},
    {"value": "female", "text": "Female"},
    {"value": "other", "text": "Other/Prefer not to say"}
    ],
    "required": true
}
```

## Time Picker

Displays a ListTile which, when tapped, shows a time picker.

```json
{
    "type": "time",
    "name": "wake_up",
    "label": "When do you wake up in the morning?",
    "icon": "alarm",
    "initial_value": "07:00",
    "format": "H:mm",
    "required": true
}
```

## Date Picker

Displays a ListTile which, when tapped, shows a date picker.

```json
{
    "type": "date",
    "name": "dob",
    "label": "Date of Birth",
    "initial_value": "1995/05/20",
    "icon": null,
    "format": "dd/MM/yyyy",
    "required": true
}
```