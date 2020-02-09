import 'package:registro_elettronico/domain/repository/preferences_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesRepositoryImpl implements PreferencesRepository {
  SharedPreferences sharedPreferences;

  PreferencesRepositoryImpl(this.sharedPreferences);

  @override
  setBool(String key, bool value) {
    return sharedPreferences.setBool(key, value);
  }

  @override
  setInt(String key, int value) {
    return sharedPreferences.setInt(key, value);
  }

  @override
  bool getBool(String key) {
    return sharedPreferences.getBool(key);
  }

  @override
  int getInt(String key) {
    return sharedPreferences.getInt(key);
  }
}
