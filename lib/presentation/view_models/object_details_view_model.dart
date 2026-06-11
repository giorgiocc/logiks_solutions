import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../domain/models/object_model.dart';
import 'objects_view_model.dart';

final objectDetailsViewModelProvider = AsyncNotifierProvider.family<
    ObjectDetailsViewModel, ObjectModel, String>(ObjectDetailsViewModel.new);

class ObjectDetailsViewModel extends AsyncNotifier<ObjectModel> {
  ObjectDetailsViewModel(this.id);

  final String id;

  @override
  Future<ObjectModel> build() {
    return ref.watch(getObjectProvider)(id);
  }

  Future<void> delete() async {
    await ref.read(deleteObjectProvider)(id);
    ref.invalidate(objectsViewModelProvider);
  }
}
