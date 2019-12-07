import 'package:moor_flutter/moor_flutter.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/db/table/profile_table.dart';

part 'profile_dao.g.dart';

@UseDao(tables: [Profiles])
class ProfileDao extends DatabaseAccessor<AppDatabase> with _$ProfileDaoMixin {
  AppDatabase db;
  ProfileDao(this.db) : super(db);

  Future<List<Profile>> getAllProfiles() => select(profiles).get();

  Stream<List<Profile>> watchAllprofiles() => select(profiles).watch();

  Future insertProfile(Profile profile) => delete(profiles).delete(profile);

  Future deleteProfile(Profile profile) => delete(profiles).delete(profile);

  Future deleteAllProfiles() =>
      (delete(profiles)..where((entry) => entry.id.isBiggerOrEqualValue(-1)))
          .go();
}
