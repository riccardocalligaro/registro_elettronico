import 'package:registro_elettronico/data/db/moor_database.dart' as db;
import 'package:registro_elettronico/domain/entity/entities.dart' as entity;
import 'package:registro_elettronico/domain/entity/login_response.dart';

class ProfileMapper {
  const ProfileMapper();

  db.Profile mapProfileEntityToProfileInsertable(entity.Profile e) {
    return db.Profile(
      id: -1,
      ident: e.ident ?? "",
      firstName: e.firstName ?? "",
      lastName: e.lastName ?? "",
      token: e.token ?? "",
      release: DateTime.parse(e.release) ?? DateTime.now(),
      expire: DateTime.parse(e.expire) ?? DateTime.now(),
    );
  }

  entity.Profile mapLoginResponseProfileToProfileEntity(
      LoginResponse resProfile) {
    return entity.Profile(
        firstName: resProfile.firstName,
        lastName: resProfile.lastName,
        token: resProfile.token,
        release: resProfile.release,
        expire: resProfile.expire);
  }
}
