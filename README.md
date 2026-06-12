# Objects App

A small CRUD app built on top of the public test API at [restful-api.dev](https://restful-api.dev)

##  Requirements

This project was built and tested with:

- **Flutter 3.44.1**
- **Dart 3.12.1**

Older versions will not work. so please run it on Flutter 3.44
or newer before reporting any build issue


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
- shared_preferences

## Project structure

```
lib/
  core/          theme, error helper, providers
  domain/        models, repository interface, use cases
  data/          data sources, repository implementation
  presentation/  screens, view models, widgets
```

Flow: Screen → ViewModel → UseCase → Repository → DataSource

## Running

```
flutter pub get
flutter run
```

Note: the API only allows updating or deleting objects created through it.
The default objects are read only, so the API returns an error for them —
the app shows that error in a snackbar

The public list endpoint only returns the default objects and never includes
objects created by users. To keep created objects visible, the app stores
their ids locally and loads them with a separate request
