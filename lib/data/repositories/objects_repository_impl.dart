import '../../domain/models/object_model.dart';
import '../../domain/repositories/objects_repository.dart';
import '../data_sources/created_ids_local_data_source.dart';
import '../data_sources/objects_remote_data_source.dart';

class ObjectsRepositoryImpl implements ObjectsRepository {
  ObjectsRepositoryImpl(this._remote, this._localIds);

  final ObjectsRemoteDataSource _remote;
  final CreatedIdsLocalDataSource _localIds;

  @override
  Future<List<ObjectModel>> getObjects() async {
    final createdIds = await _localIds.load();
    final objects = await _remote.getObjects();
    if (createdIds.isNotEmpty) {
      objects.addAll(await _remote.getObjectsByIds(createdIds));
    }
    return objects;
  }

  @override
  Future<ObjectModel> getObject(String id) => _remote.getObject(id);

  @override
  Future<ObjectModel> createObject(String name, Map<String, dynamic>? data) async {
    final created = await _remote.createObject(name, data);
    await _localIds.add(created.id);
    return created;
  }

  @override
  Future<ObjectModel> updateObject(ObjectModel object) =>
      _remote.updateObject(object);

  @override
  Future<void> deleteObject(String id) async {
    await _remote.deleteObject(id);
    await _localIds.remove(id);
  }
}
