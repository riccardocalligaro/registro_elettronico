import 'package:moor_flutter/moor_flutter.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/db/table/profile_table.dart';

part 'profile_dao.g.dart';

@UseDao(tables: [Profiles])
class ProfileDao extends DatabaseAccessor<AppDatabase> with _$ProfileDaoMixin {
  AppDatabase db;
  ProfileDao(this.db) : super(db);

  Future<List<Insertable<Profile>>> getAllProfiles() => select(profiles).get();

  Future<Profile> getProfile() => select(profiles).getSingle();

  Future updateProfile(Profile profile) => update(profiles).replace(profile);

  Stream<List<Insertable<Profile>>> watchAllprofiles() =>
      select(profiles).watch();

  void updateUserName({String token, DateTime expire, DateTime release}) {
    final _entry = ProfilesCompanion(
      token: Value(token),
      expire: Value(expire),
      release: Value(expire),
    );
    update(profiles).write(_entry);
  }

  Future insertProfile(Insertable<Profile> profile) =>
      into(profiles).insert(profile);

  Future deleteProfile(Insertable<Profile> profile) =>
      delete(profiles).delete(profile);

  Future deleteAllProfiles() =>
      (delete(profiles)..where((entry) => entry.id.isBiggerOrEqualValue(-1)))
          .go();
}
