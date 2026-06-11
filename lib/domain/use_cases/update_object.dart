import '../models/object_model.dart';
import '../repositories/objects_repository.dart';

class UpdateObject {
  const UpdateObject(this._repository);

  final ObjectsRepository _repository;

  Future<ObjectModel> call(ObjectModel object) =>
      _repository.updateObject(object);
}
