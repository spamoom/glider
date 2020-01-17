# Introduction

Glider is two things:

1. A schema for defining the structure and behavior of mobile apps using JSON
2. A Flutter package which allows developers to create mobile applications using Glider definitions

## Why did we build Glider?

In 2018, the mobile dev community fell in love with [Flutter](https://flutter.io/). It significantly reduced the workload involved in creating a beautiful cross-platform mobile app.

However, a problem it doesn't solve fully is the fact that most mobile apps consist of very similar UI components and behaviours. Naturally, Flutter has to cater for as many UIs as possible, but that does increase the workload when it comes to using basic, built-in Material Components.

So we build Glider, which provides a way of defining mobile apps using JSON. Glider supports Flutter's built-in Material Components, allowing developers to create beautiful, simple apps with minimal boilerplate.

## Apps defined in the back-end

A perk of this architecture is that Glider apps can retrieve their definitions on startup from an API. This means two things:

1. The actual Flutter project for a Glider app is almost impossibly small, simply instantiating a Glider using a URL
2. App updates can be performed by back-end developers without any need to publish a new version on the App Store/Play Store

## Limitations

Glider is designed to be both minimal and opinionated. Glider apps follow the [Material Design](https://material.io/) guidelines as closely as possible, and we provide limited options for theming.

You shouldn't expect to have much control over the intricate design details of a Glider app. You can define a colour scheme and a few other theme properties, which will be applied across the app according to the Material guidelines. **Individual widgets are not themable at this time.**

**Next: [Installation](installation.md)**
