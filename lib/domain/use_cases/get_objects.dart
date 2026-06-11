import '../models/object_model.dart';
import '../repositories/objects_repository.dart';

class GetObjects {
  const GetObjects(this._repository);

  final ObjectsRepository _repository;

  Future<List<ObjectModel>> call() => _repository.getObjects();
}
