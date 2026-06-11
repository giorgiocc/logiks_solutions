import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/objects_provider.dart';
import '../services/api_service.dart';
import '../widgets/error_view.dart';
import '../widgets/object_tile.dart';

class ObjectsScreen extends ConsumerWidget {
  const ObjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final objects = ref.watch(objectsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Objects')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/edit'),
        child: const Icon(Icons.add),
      ),
      body: objects.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorView(
          message: errorMessage(error),
          onRetry: () => ref.invalidate(objectsProvider),
        ),
        data: (items) {
          return RefreshIndicator(
            onRefresh: () => ref.refresh(objectsProvider.future),
            child: items.isEmpty
                ? ListView(
                    children: const [
                      SizedBox(height: 200),
                      Center(child: Text('No objects yet')),
                    ],
                  )
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final object = items[index];
                      return ObjectTile(
                        object: object,
                        onTap: () => context.push('/object/${object.id}'),
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}
