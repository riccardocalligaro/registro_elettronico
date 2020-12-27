import 'package:registro_elettronico/core/domain/repository/preferences_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesRepositoryImpl implements PreferencesRepository {
  SharedPreferences sharedPreferences;

  PreferencesRepositoryImpl(this.sharedPreferences);

  @override
  Future<bool> setBool(String key, bool value) {
    return sharedPreferences.setBool(key, value);
  }

  @override
  Future<bool> setInt(String key, int value) {
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
