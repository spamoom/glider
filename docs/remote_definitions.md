# Remote Definitions

Cocoon provides a couple of useful methods for retrieving your definition from a remote location. The supported location types are REST APIs and Cloud Firestores.

## REST API

Simply use `Cocoon.appFromUrl(https://api.myapp.com/v1/home, fallback)` to create a widget based on the definition found at the provided URL. A loading animation will be displayed while the definition is being downloaded.

Additionally you can pass a `fallback` String, which is the definition to show if the definition could not be retrieved for some reason.

## Cloud Firestore

*This requires you to [add Firebase and Cloud Firestore to your project](https://firebase.google.com/docs/flutter/setup).*

Use `Cocoon.appFromDocumentReference(Firestore.instance.document('collection/document1'), fallback)` to create a widget based on the definition found in the provided document reference. A loading animation will be displayed while the definition is being downloaded.

This method returns an auto-updating Cocoon; in other words, changes to the definition document in your Firestore will be immediately reflected in the app.

Additionally you can pass a `fallback` String, which is the definition to show if the definition could not be retrieved for some reason.