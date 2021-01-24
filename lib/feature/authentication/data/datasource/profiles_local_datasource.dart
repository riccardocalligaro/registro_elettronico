import 'package:moor/moor.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/authentication/data/model/profile_local_model.dart';

part 'profiles_local_datasource.g.dart';

@UseDao(tables: [Profiles])
class ProfilesLocalDatasource extends DatabaseAccessor<AppDatabase>
    with _$ProfilesLocalDatasourceMixin {
  AppDatabase db;

  ProfilesLocalDatasource(this.db) : super(db);

  Future<List<ProfileLocalModel>> getAllProfiles() => select(profiles).get();

  Future insertProfile(ProfileLocalModel profile) =>
      into(profiles).insertOnConflictUpdate(profile);

  Future deleteProfile(ProfileLocalModel profile) =>
      delete(profiles).delete(profile);

  Future updateProfile(ProfileLocalModel profile) =>
      update(profiles).replace(profile);

  Future deleteAllProfiles() => delete(profiles).go();

  Future<ProfileLocalModel> getLoggedInUser() {
    return (select(profiles)..where((g) => g.currentlyLoggedIn)).getSingle();
  }
}
