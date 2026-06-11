import '../models/object_model.dart';
import '../repositories/objects_repository.dart';

class CreateObject {
  const CreateObject(this._repository);

  final ObjectsRepository _repository;

  Future<ObjectModel> call(String name, Map<String, dynamic>? data) =>
      _repository.createObject(name, data);
}
