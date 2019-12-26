import 'package:registro_elettronico/data/db/moor_database.dart' as db;
import 'package:registro_elettronico/domain/entity/api_responses/login_response.dart';
import 'package:registro_elettronico/domain/entity/entities.dart' as entity;
import 'package:registro_elettronico/utils/profile_utils.dart';

class ProfileMapper {
  const ProfileMapper();

  /// Transorms the profile from an entity to an object that can be
  /// inserted in the database
  db.Profile mapProfileEntityToProfileInsertable(entity.Profile e) {
    return db.Profile(
      id: -1,
      ident: e.ident,
      studentId: ProfileUtils.getIdFromIdent(e.ident),
      passwordKey: ProfileUtils.createCryptoRandomString(),
      firstName: e.firstName ?? "",
      lastName: e.lastName ?? "",
      token: e.token ?? "",
      release: DateTime.parse(e.release) ?? DateTime.now(),
      expire: DateTime.parse(e.expire) ?? DateTime.now(),
    );
  }

  /// Converts the login response that we get from calsseviva into a profile entity
  entity.Profile mapLoginResponseProfileToProfileEntity(
      LoginResponse resProfile) {
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
