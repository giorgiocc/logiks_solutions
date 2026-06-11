# Objects App

A small CRUD app built on top of the public test API at [restful-api.dev](https://restful-api.dev)

## Features

- List of objects with pull to refresh
- Details screen showing all object fields
- Create, edit and delete objects
- Loading, error and empty states

## Stack

- Flutter 
- Riverpod
- Dio 
- go_router

## Project structure

```
lib/
  models/      data models
  services/    API client
  providers/   Riverpod
  screens/     list, details, create/edit screens
  widgets/     reusable widgets
```

## Running

```
flutter pub get
flutter run
```

Note: the API only allows updating or deleting objects created through it.
The default objects are read only, so the API returns an error for them —
the app shows that error in a snackbar.

The public list endpoint only returns the default objects and never includes
objects created by users. To keep created objects visible, the app stores
their ids locally and loads them with a separate request.
