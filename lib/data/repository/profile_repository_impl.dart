import 'package:registro_elettronico/data/db/dao/profile_dao.dart';
import 'package:registro_elettronico/data/repository/mapper/profile_mapper.dart';
import 'package:registro_elettronico/domain/entity/entities.dart';
import 'package:registro_elettronico/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileDao profileDao;

  /// The profile mapper transforms an entity to the respective database enetity.
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
  Future insertProfile({Profile profile}) => profileDao.insertProfile(
      profileMapper.mapProfileEntityToProfileInsertable(profile));

  @override
  Future deleteAllProfiles() => profileDao.deleteAllProfiles();

  @override
  Future<String> getToken() async {
    final profile = await profileDao.getProfile();
    return profile.token;
  }
}
