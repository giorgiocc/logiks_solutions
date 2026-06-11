import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../domain/models/object_model.dart';
import 'object_details_view_model.dart';
import 'objects_view_model.dart';

final editObjectViewModelProvider =
    NotifierProvider.autoDispose<EditObjectViewModel, AsyncValue<void>>(
  EditObjectViewModel.new,
);

class EditObjectViewModel extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<bool> submit({
    ObjectModel? existing,
    required String name,
    Map<String, dynamic>? data,
  }) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      if (existing == null) {
        await ref.read(createObjectProvider)(name, data);
      } else {
        await ref.read(updateObjectProvider)(
          ObjectModel(id: existing.id, name: name, data: data),
        );
      }
    });
    state = result;

    if (result.hasError) return false;

    ref.invalidate(objectsViewModelProvider);
    if (existing != null) {
      ref.invalidate(objectDetailsViewModelProvider(existing.id));
    }
    return true;
  }
}
