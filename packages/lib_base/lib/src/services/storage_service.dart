

abstract class StorageService {

  Future<bool> saveString(String key, String value);

  Future<String?> getString(String key);

  Future<bool> saveInt(String key, int value);

  Future<int?> getInt(String key);

  Future<bool> saveBool(String key, bool value);

  Future<bool?> getBool(String key);

  Future<bool> remove(String key);

  Future<bool> clear();
}
