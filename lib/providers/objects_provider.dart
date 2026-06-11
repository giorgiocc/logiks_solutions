import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/object_model.dart';
import '../services/api_service.dart';
import '../services/created_ids_store.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final createdIdsStoreProvider =
    Provider<CreatedIdsStore>((ref) => CreatedIdsStore());

final objectsProvider = FutureProvider<List<ObjectModel>>((ref) async {
  final api = ref.watch(apiServiceProvider);
  final createdIds = await ref.watch(createdIdsStoreProvider).load();

  final objects = await api.getObjects();
  if (createdIds.isNotEmpty) {
    objects.addAll(await api.getObjectsByIds(createdIds));
  }
  return objects;
});

final objectProvider = FutureProvider.family<ObjectModel, String>((ref, id) {
  return ref.watch(apiServiceProvider).getObject(id);
});
