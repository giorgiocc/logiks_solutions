import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../domain/models/object_model.dart';

final objectsViewModelProvider =
    AsyncNotifierProvider<ObjectsViewModel, List<ObjectModel>>(
  ObjectsViewModel.new,
);

class ObjectsViewModel extends AsyncNotifier<List<ObjectModel>> {
  @override
  Future<List<ObjectModel>> build() {
    return ref.watch(getObjectsProvider)();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(getObjectsProvider)());
  }
}
