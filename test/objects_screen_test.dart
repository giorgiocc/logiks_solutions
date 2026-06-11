import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:objects_app/core/providers.dart';
import 'package:objects_app/domain/models/object_model.dart';
import 'package:objects_app/domain/repositories/objects_repository.dart';
import 'package:objects_app/presentation/screens/objects_screen.dart';

class FakeObjectsRepository implements ObjectsRepository {
  FakeObjectsRepository({this.objects = const [], this.failing = false});

  final List<ObjectModel> objects;
  bool failing;

  @override
  Future<List<ObjectModel>> getObjects() async {
    if (failing) throw Exception('network error');
    return List.of(objects);
  }

  @override
  Future<ObjectModel> getObject(String id) async =>
      objects.firstWhere((object) => object.id == id);

  @override
  Future<ObjectModel> createObject(String name, Map<String, dynamic>? data) async =>
      ObjectModel(id: '100', name: name, data: data);

  @override
  Future<ObjectModel> updateObject(ObjectModel object) async => object;

  @override
  Future<void> deleteObject(String id) async {}
}

Widget buildApp(ObjectsRepository repository) {
  return ProviderScope(
    retry: (retryCount, error) => null,
    overrides: [objectsRepositoryProvider.overrideWithValue(repository)],
    child: const MaterialApp(home: ObjectsScreen()),
  );
}

void main() {
  testWidgets('shows loading indicator while fetching', (tester) async {
    await tester.pumpWidget(buildApp(FakeObjectsRepository()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump();
  });

  testWidgets('shows id and name for each object', (tester) async {
    final repository = FakeObjectsRepository(objects: const [
      ObjectModel(id: '1', name: 'Google Pixel 6 Pro'),
      ObjectModel(id: '2', name: 'Apple iPhone 12 Mini'),
    ]);

    await tester.pumpWidget(buildApp(repository));
    await tester.pump();

    expect(find.text('Google Pixel 6 Pro'), findsOneWidget);
    expect(find.text('ID: 1'), findsOneWidget);
    expect(find.text('Apple iPhone 12 Mini'), findsOneWidget);
    expect(find.text('ID: 2'), findsOneWidget);
  });

  testWidgets('shows empty state when there are no objects', (tester) async {
    await tester.pumpWidget(buildApp(FakeObjectsRepository()));
    await tester.pump();

    expect(find.text('No objects yet'), findsOneWidget);
  });

  testWidgets('shows error view and recovers on retry', (tester) async {
    final repository = FakeObjectsRepository(
      objects: const [ObjectModel(id: '1', name: 'Google Pixel 6 Pro')],
      failing: true,
    );

    await tester.pumpWidget(buildApp(repository));
    await tester.pump();

    expect(find.text('Something went wrong'), findsOneWidget);

    repository.failing = false;
    await tester.tap(find.text('Retry'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Google Pixel 6 Pro'), findsOneWidget);
  });
}
