# The Aspect Ratio

This widget can be used to make it's child have a particular aspect ratio. You'll most commonly use this with images.

```json
{
    "type": "aspect_ratio",
    "aspect_ratio": 1.7,
    "child": {}
}
```

To calculate the `aspect_ratio` value, simply divide the horizontal size by the vertical size.

* 16:9 is 16/9 = 1.7
* 4:3 is 4/3 = 1.333...
* 1:1 (square) is 1/1 = 1
