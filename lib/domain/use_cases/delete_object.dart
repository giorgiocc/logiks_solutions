import '../repositories/objects_repository.dart';

class DeleteObject {
  const DeleteObject(this._repository);

  final ObjectsRepository _repository;

  Future<void> call(String id) => _repository.deleteObject(id);
}
