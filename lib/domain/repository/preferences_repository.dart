abstract class PreferencesRepository {
  int getInt(String key);

  bool getBool(String key);

  setInt(String key, int value);

  setBool(String key, bool value);
}
