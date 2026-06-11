import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:objects_app/core/providers.dart';
import 'package:objects_app/domain/models/object_model.dart';
import 'package:objects_app/domain/repositories/objects_repository.dart';
import 'package:objects_app/presentation/screens/details_screen.dart';

class FakeObjectsRepository implements ObjectsRepository {
  FakeObjectsRepository(this.object);

  final ObjectModel object;

  @override
  Future<ObjectModel> getObject(String id) async => object;

  @override
  Future<List<ObjectModel>> getObjects() async => [object];

  @override
  Future<ObjectModel> createObject(String name, Map<String, dynamic>? data) async =>
      object;

  @override
  Future<ObjectModel> updateObject(ObjectModel object) async => object;

  @override
  Future<void> deleteObject(String id) async {}
}

Widget buildApp(ObjectModel object) {
  return ProviderScope(
    retry: (retryCount, error) => null,
    overrides: [
      objectsRepositoryProvider.overrideWithValue(FakeObjectsRepository(object)),
    ],
    child: MaterialApp(home: DetailsScreen(id: object.id)),
  );
}

void main() {
  testWidgets('renders name and all data fields without overflow',
      (tester) async {
    const object = ObjectModel(
      id: 'ff8081819d82fab6019eb77a25087409',
      name: 'Apple MacBook Pro 16, very long name that should ellipsize nicely',
      data: {
        'year': 2019,
        'price': 1849.99,
        'CPU model': 'Intel Core i9 with a long descriptive value',
      },
    );

    await tester.pumpWidget(buildApp(object));
    await tester.pump();

    expect(find.textContaining('Apple MacBook Pro 16'), findsOneWidget);
    expect(find.text('year'), findsOneWidget);
    expect(find.text('CPU model'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('opens a delete confirmation with both actions', (tester) async {
    const object = ObjectModel(id: '100', name: 'Test', data: null);

    await tester.pumpWidget(buildApp(object));
    await tester.pump();

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Delete object?'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
