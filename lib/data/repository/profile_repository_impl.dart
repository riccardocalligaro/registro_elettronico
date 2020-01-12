import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:registro_elettronico/data/db/dao/profile_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart' as db;
import 'package:registro_elettronico/data/repository/mapper/profile_mapper.dart';
import 'package:registro_elettronico/domain/entity/entities.dart';
import 'package:registro_elettronico/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileDao profileDao;
  FlutterSecureStorage flutterSecureStorage;
  ProfileMapper profileMapper;

  ProfileRepositoryImpl(this.profileDao, this.profileMapper);

  Future<bool> isLoggedIn() async {
    final profiles = await profileDao.getAllProfiles();
    return (profiles.length >= 1);
  }

  @override
  Future deleteProfile({Profile profile}) => profileDao.deleteProfile(
      profileMapper.mapProfileEntityToProfileInsertable(profile));

  @override
  Future insertProfile({Profile profile}) {
    final convertedProfile =
        profileMapper.mapProfileEntityToProfileInsertable(profile);
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
        profileMapper.mapProfileEntityToProfileInsertable(profile));
  }
}
