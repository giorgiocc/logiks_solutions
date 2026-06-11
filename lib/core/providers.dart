import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/data_sources/created_ids_local_data_source.dart';
import '../data/data_sources/objects_remote_data_source.dart';
import '../data/repositories/objects_repository_impl.dart';
import '../domain/repositories/objects_repository.dart';
import '../domain/use_cases/create_object.dart';
import '../domain/use_cases/delete_object.dart';
import '../domain/use_cases/get_object.dart';
import '../domain/use_cases/get_objects.dart';
import '../domain/use_cases/update_object.dart';

final objectsRemoteDataSourceProvider =
    Provider<ObjectsRemoteDataSource>((ref) => ObjectsRemoteDataSource());

final createdIdsLocalDataSourceProvider =
    Provider<CreatedIdsLocalDataSource>((ref) => CreatedIdsLocalDataSource());

final objectsRepositoryProvider = Provider<ObjectsRepository>((ref) {
  return ObjectsRepositoryImpl(
    ref.watch(objectsRemoteDataSourceProvider),
    ref.watch(createdIdsLocalDataSourceProvider),
  );
});

final getObjectsProvider =
    Provider((ref) => GetObjects(ref.watch(objectsRepositoryProvider)));

final getObjectProvider =
    Provider((ref) => GetObject(ref.watch(objectsRepositoryProvider)));

final createObjectProvider =
    Provider((ref) => CreateObject(ref.watch(objectsRepositoryProvider)));

final updateObjectProvider =
    Provider((ref) => UpdateObject(ref.watch(objectsRepositoryProvider)));

final deleteObjectProvider =
    Provider((ref) => DeleteObject(ref.watch(objectsRepositoryProvider)));
