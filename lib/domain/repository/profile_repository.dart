import 'package:flutter/material.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:registro_elettronico/data/db/moor_database.dart' as db;
import 'package:registro_elettronico/domain/entity/entities.dart';
import 'package:tuple/tuple.dart';

abstract class ProfileRepository {
  /// Returns true if the user is logged in
  Future<bool> isLoggedIn();

  /// Inserts a profile in the database
  Future insertProfile({@required Profile profile});

  /// Deletes a profile from the database
  Future deleteProfile({@required Profile profile});

  Future updateProfile(Profile profile);

  /// Deletes all profiles from the database
  Future deleteAllProfiles();

  /// Gets the token
  Future getToken();

  Future<db.Profile> getDbProfile();

  Future<Tuple2<db.Profile, String>> getUserAndPassword();
}
