import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/api_error.dart';
import '../../core/theme.dart';
import '../view_models/objects_view_model.dart';
import '../widgets/error_view.dart';
import '../widgets/object_tile.dart';

class ObjectsScreen extends ConsumerWidget {
  const ObjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final objects = ref.watch(objectsViewModelProvider);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Objects'),
            if (objects.hasValue)
              Text(
                '${objects.value!.length} items',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: scheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/edit'),
        icon: const Icon(Icons.add),
        label: const Text('New', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: objects.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorView(
          message: errorMessage(error),
          onRetry: () => ref.read(objectsViewModelProvider.notifier).refresh(),
        ),
        data: (items) => RefreshIndicator(
          backgroundColor: surfaceHigh,
          color: scheme.primary,
          onRefresh: () => ref.read(objectsViewModelProvider.notifier).refresh(),
          child: items.isEmpty
              ? const _EmptyState()
              : ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final object = items[index];
                    return ObjectTile(
                      object: object,
                      onTap: () => context.push('/object/${object.id}'),
                    );
                  },
                ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ListView(
      children: [
        const SizedBox(height: 160),
        Center(
          child: Container(
            height: 88,
            width: 88,
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.inbox_outlined, size: 40, color: scheme.primary),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: Text(
            'No objects yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        const SizedBox(height: 6),
        Center(
          child: Text(
            'Tap New to create your first one',
            style: TextStyle(color: scheme.onSurfaceVariant),
          ),
        ),
      ],
    );
  }
}
