import '../models/object_model.dart';
import '../repositories/objects_repository.dart';

class GetObject {
  const GetObject(this._repository);

  final ObjectsRepository _repository;

  Future<ObjectModel> call(String id) => _repository.getObject(id);
}
