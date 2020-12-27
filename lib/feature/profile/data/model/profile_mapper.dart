import 'package:registro_elettronico/core/data/local/moor_database.dart' as db;
import 'package:registro_elettronico/feature/login/data/model/login_response_remote_model.dart';
import 'package:registro_elettronico/feature/profile/data/model/profile_entity.dart'
    as entity;
import 'package:registro_elettronico/utils/profile_utils.dart';

class ProfileMapper {
  /// Transorms the profile from an entity to an object that can be
  /// inserted in the database
  static db.Profile mapProfileEntityToProfileInsertable(entity.Profile e) {
    return db.Profile(
      id: -1,
      ident: e.ident,
      studentId: ProfileUtils.getIdFromIdent(e.ident),
      firstName: e.firstName ?? "",
      lastName: e.lastName ?? "",
      token: e.token ?? "",
      release: DateTime.parse(e.release) ?? DateTime.now(),
      expire: DateTime.parse(e.expire) ?? DateTime.now(),
      // isActive: true
    );
  }

  /// Converts the login response that we get from calsseviva into a profile entity
  static entity.Profile mapLoginResponseProfileToProfileEntity(
    LoginResponse resProfile,
  ) {
    return entity.Profile(
      firstName: resProfile.firstName ?? "",
      lastName: resProfile.lastName ?? "",
      ident: resProfile.ident ?? "",
      token: resProfile.token ?? "",
      release: resProfile.release ?? DateTime.now(),
      expire: resProfile.expire ?? DateTime.now(),
    );
  }
}
