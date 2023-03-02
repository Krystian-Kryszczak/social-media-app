import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();
  static Future<bool> writeString({required String key, required String value}) => _prefs.then((storage) => storage.setString(key, value));
  static Future<String?> readString({required String key}) => _prefs.then((storage) => storage.getString(key));
  static Future<bool> writeBool({required String key, required bool value}) => _prefs.then((storage) => storage.setBool(key, value));
  static Future<bool?> readBool({required String key}) => _prefs.then((storage) => storage.getBool(key));
  static Future<bool> writeInt({required String key, required int value}) => _prefs.then((storage) => storage.setInt(key, value));
  static Future<int?> readInt({required String key}) => _prefs.then((storage) => storage.getInt(key));
  static Future<bool> writeDouble({required String key, required double value}) => _prefs.then((storage) => storage.setDouble(key, value));
  static Future<double?> readDouble({required String key}) => _prefs.then((storage) => storage.getDouble(key));
  static Future<bool> writeStringList({required String key, required List<String> value}) => _prefs.then((storage) => storage.setStringList(key, value));
  static Future<List<String>?> readStringList({required String key}) => _prefs.then((storage) => storage.getStringList(key));
  static Future<Object?> readObject({required String key}) => _prefs.then((storage) => storage.get(key));
  static Future<bool> containsKey({required String key}) => _prefs.then((storage) => storage.containsKey(key));
  static Future<Set<String>> getKeys() => _prefs.then((storage) => storage.getKeys());
  static Future<bool> remove({required String key}) => _prefs.then((storage) => storage.remove(key));
  static Future<bool> clear() => _prefs.then((storage) => storage.clear());
  static Future<void> reload() => _prefs.then((storage) => storage.reload());
}
