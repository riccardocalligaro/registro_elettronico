abstract class PreferencesRepository {
  int getInt(String key);

  bool getBool(String key);

  Future<bool> setInt(String key, int value);

  Future<bool> setBool(String key, bool value);
}
