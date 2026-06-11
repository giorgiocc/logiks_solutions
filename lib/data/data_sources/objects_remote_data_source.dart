import 'package:dio/dio.dart';

import '../../domain/models/object_model.dart';

class ObjectsRemoteDataSource {
  ObjectsRemoteDataSource({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'https://api.restful-api.dev',
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
                listFormat: ListFormat.multi,
              ),
            );

  final Dio _dio;

  Future<List<ObjectModel>> getObjects() async {
    final response = await _dio.get('/objects');
    final items = response.data as List;
    return items.map((item) => ObjectModel.fromJson(item)).toList();
  }

  Future<List<ObjectModel>> getObjectsByIds(List<String> ids) async {
    final response = await _dio.get('/objects', queryParameters: {'id': ids});
    final items = response.data as List;
    return items.map((item) => ObjectModel.fromJson(item)).toList();
  }

  Future<ObjectModel> getObject(String id) async {
    final response = await _dio.get('/objects/$id');
    return ObjectModel.fromJson(response.data);
  }

  Future<ObjectModel> createObject(String name, Map<String, dynamic>? data) async {
    final response = await _dio.post(
      '/objects',
      data: {'name': name, 'data': data},
    );
    return ObjectModel.fromJson(response.data);
  }

  Future<ObjectModel> updateObject(ObjectModel object) async {
    final response = await _dio.put(
      '/objects/${object.id}',
      data: object.toJson(),
    );
    return ObjectModel.fromJson(response.data);
  }

  Future<void> deleteObject(String id) async {
    await _dio.delete('/objects/$id');
  }
}
