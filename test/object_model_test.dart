import 'package:flutter_test/flutter_test.dart';
import 'package:objects_app/domain/models/object_model.dart';

void main() {
  test('parses json with data', () {
    final object = ObjectModel.fromJson({
      'id': '1',
      'name': 'Google Pixel 6 Pro',
      'data': {'color': 'Cloudy White', 'capacity': '128 GB'},
    });

    expect(object.id, '1');
    expect(object.name, 'Google Pixel 6 Pro');
    expect(object.data?['color'], 'Cloudy White');
    expect(object.data?['capacity'], '128 GB');
  });

  test('parses json with null data', () {
    final object = ObjectModel.fromJson({
      'id': '2',
      'name': 'Apple iPhone 12 Mini',
      'data': null,
    });

    expect(object.id, '2');
    expect(object.data, isNull);
  });

  test('toJson does not include id', () {
    const object = ObjectModel(id: '5', name: 'Test', data: {'price': 100});

    final json = object.toJson();

    expect(json.containsKey('id'), isFalse);
    expect(json['name'], 'Test');
    expect(json['data'], {'price': 100});
  });
}
