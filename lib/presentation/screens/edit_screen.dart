import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/api_error.dart';
import '../../domain/models/object_model.dart';
import '../view_models/edit_object_view_model.dart';

class EditScreen extends ConsumerStatefulWidget {
  const EditScreen({super.key, this.object});

  final ObjectModel? object;

  @override
  ConsumerState<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends ConsumerState<EditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  final List<_DataField> _fields = [];

  bool get _isEditing => widget.object != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.object?.name ?? '');
    widget.object?.data?.forEach((key, value) {
      _fields.add(_DataField(key: key, value: '$value'));
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    for (final field in _fields) {
      field.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final data = <String, dynamic>{};
    for (final field in _fields) {
      final key = field.keyController.text.trim();
      if (key.isEmpty) continue;
      final value = field.valueController.text.trim();
      data[key] = num.tryParse(value) ?? value;
    }

    final success = await ref.read(editObjectViewModelProvider.notifier).submit(
          existing: widget.object,
          name: _nameController.text.trim(),
          data: data.isEmpty ? null : data,
        );

    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEditing ? 'Object updated' : 'Object created')),
      );
      context.pop();
    } else {
      final error = ref.read(editObjectViewModelProvider).error!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage(error))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final saving = ref.watch(editObjectViewModelProvider).isLoading;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit object' : 'New object')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            const _SectionLabel('Name'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(hintText: 'Object name'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const _SectionLabel('Data'),
                FilledButton.tonalIcon(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 40),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => setState(() => _fields.add(_DataField())),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add field'),
                ),
              ],
            ),
            if (_fields.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'No fields yet. Add key / value pairs.',
                  style: TextStyle(color: scheme.outline),
                ),
              ),
            for (var i = 0; i < _fields.length; i++) _buildFieldCard(i),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: saving ? null : _save,
              child: saving
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(_isEditing ? 'Save changes' : 'Create object'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldCard(int index) {
    final field = _fields[index];

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 8, 14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    TextFormField(
                      controller: field.keyController,
                      decoration: const InputDecoration(hintText: 'Key'),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: field.valueController,
                      decoration: const InputDecoration(hintText: 'Value'),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.remove_circle_outline,
                  color: Theme.of(context).colorScheme.error,
                ),
                onPressed: () => setState(() => _fields.removeAt(index).dispose()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class _DataField {
  _DataField({String key = '', String value = ''})
      : keyController = TextEditingController(text: key),
        valueController = TextEditingController(text: value);

  final TextEditingController keyController;
  final TextEditingController valueController;

  void dispose() {
    keyController.dispose();
    valueController.dispose();
  }
}
