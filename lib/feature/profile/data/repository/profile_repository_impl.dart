import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:registro_elettronico/feature/profile/data/dao/profile_dao.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart' as db;
import 'package:registro_elettronico/feature/profile/data/model/profile_mapper.dart';
import 'package:registro_elettronico/domain/entity/entities.dart';
import 'package:registro_elettronico/feature/profile/domain/repository/profile_repository.dart';
import 'package:tuple/tuple.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileDao profileDao;
  FlutterSecureStorage flutterSecureStorage;

  ProfileRepositoryImpl(this.profileDao, this.flutterSecureStorage);

  Future<bool> isLoggedIn() async {
    final profiles = await profileDao.getAllProfiles();

    return (profiles.length >= 1);
  }

  @override
  Future deleteProfile({Profile profile}) => profileDao.deleteProfile(
      ProfileMapper.mapProfileEntityToProfileInsertable(profile));

  @override
  Future insertProfile({
    Profile profile,
  }) {
    final convertedProfile =
        ProfileMapper.mapProfileEntityToProfileInsertable(profile);
    return profileDao.insertProfile(convertedProfile);
  }

  @override
  Future deleteAllProfiles() => profileDao.deleteAllProfiles();

  @override
  Future<String> getToken() async {
    final profile = await profileDao.getProfile();
    return profile.token;
  }

  @override
  Future<db.Profile> getDbProfile() async {
    final profile = await profileDao.getProfile();
    return profile;
  }

  @override
  Future updateProfile(Profile profile) {
    return profileDao.updateProfile(
      ProfileMapper.mapProfileEntityToProfileInsertable(profile),
    );
  }

  @override
  Future<Tuple2<db.Profile, String>> getUserAndPassword() async {
    final profile = await profileDao.getProfile();
    final password = await flutterSecureStorage.read(key: profile.ident);
    return Tuple2(profile, password);
  }
}
