import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/object_model.dart';
import '../providers/objects_provider.dart';
import '../services/api_service.dart';

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
  bool _saving = false;

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

    setState(() => _saving = true);

    final api = ref.read(apiServiceProvider);
    final name = _nameController.text.trim();

    try {
      if (_isEditing) {
        await api.updateObject(ObjectModel(
          id: widget.object!.id,
          name: name,
          data: data.isEmpty ? null : data,
        ));
        ref.invalidate(objectProvider(widget.object!.id));
      } else {
        final created = await api.createObject(name, data.isEmpty ? null : data);
        await ref.read(createdIdsStoreProvider).add(created.id);
      }
      ref.invalidate(objectsProvider);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEditing ? 'Object updated' : 'Object created')),
      );
      context.pop();
    } catch (error) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage(error))),
      );
    }
  }

  Widget _buildFieldRow(int index) {
    final field = _fields[index];

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: field.keyController,
              decoration: const InputDecoration(
                labelText: 'Key',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              controller: field.valueController,
              decoration: const InputDecoration(
                labelText: 'Value',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => setState(() => _fields.removeAt(index).dispose()),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit object' : 'New object')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            Text('Data', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            for (var i = 0; i < _fields.length; i++) _buildFieldRow(i),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => setState(() => _fields.add(_DataField())),
                icon: const Icon(Icons.add),
                label: const Text('Add field'),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(_isEditing ? 'Save' : 'Create'),
            ),
          ],
        ),
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
