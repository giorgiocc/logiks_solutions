import 'package:flutter/material.dart';

import '../models/object_model.dart';

class ObjectTile extends StatelessWidget {
  const ObjectTile({super.key, required this.object, required this.onTap});

  final ObjectModel object;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(object.name.isEmpty ? '?' : object.name[0].toUpperCase()),
        ),
        title: Text(object.name),
        subtitle: Text(
          'ID: ${object.id}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
