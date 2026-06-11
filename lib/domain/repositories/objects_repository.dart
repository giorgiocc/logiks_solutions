import '../models/object_model.dart';

abstract class ObjectsRepository {
  Future<List<ObjectModel>> getObjects();
  Future<ObjectModel> getObject(String id);
  Future<ObjectModel> createObject(String name, Map<String, dynamic>? data);
  Future<ObjectModel> updateObject(ObjectModel object);
  Future<void> deleteObject(String id);
}
