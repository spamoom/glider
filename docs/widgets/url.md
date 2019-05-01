# URL Widget

In your API, separate pages may come from separate endpoints.

To enable this, you can replace `scaffold` widgets with a `url` widget pointing to the definition of the page in your API.

```json
{
    "type": "url",
    "url": "https://api.athing.com/v1/details/1.json"
}
```

The widget returned by the URL **must** be a [`scaffold`](scaffold.md).

## See Also

* [Scaffold](scaffold.md)