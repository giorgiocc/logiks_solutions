import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'models/object_model.dart';
import 'screens/details_screen.dart';
import 'screens/edit_screen.dart';
import 'screens/objects_screen.dart';

void main() {
  runApp(
    ProviderScope(
      retry: (retryCount, error) => null,
      child: const ObjectsApp(),
    ),
  );
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ObjectsScreen(),
    ),
    GoRoute(
      path: '/object/:id',
      builder: (context, state) =>
          DetailsScreen(id: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/edit',
      builder: (context, state) =>
          EditScreen(object: state.extra as ObjectModel?),
    ),
  ],
);

class ObjectsApp extends StatelessWidget {
  const ObjectsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Objects',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
      ),
      routerConfig: _router,
    );
  }
}
