class ObjectModel {
  final String id;
  final String name;
  final Map<String, dynamic>? data;

  const ObjectModel({required this.id, required this.name, this.data});

  factory ObjectModel.fromJson(Map<String, dynamic> json) {
    return ObjectModel(
      id: json['id'].toString(),
      name: json['name'] as String? ?? '',
      data: json['data'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'data': data};
  }
}
