import 'package:shared_preferences/shared_preferences.dart';

class CreatedIdsLocalDataSource {
  static const _key = 'created_object_ids';

  Future<List<String>> load() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  Future<void> add(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_key) ?? [];
    if (!ids.contains(id)) {
      ids.add(id);
      await prefs.setStringList(_key, ids);
    }
  }

  Future<void> remove(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_key) ?? [];
    if (ids.remove(id)) {
      await prefs.setStringList(_key, ids);
    }
  }
}
