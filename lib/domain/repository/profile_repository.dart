import 'package:flutter/material.dart';
import 'package:registro_elettronico/domain/entity/entities.dart';

abstract class ProfileRepository {
  /// Returns true if the user is logged in
  Future<bool> isLoggedIn();

  /// Inserts a profile in the database
  Future insertProfile({@required Profile profile});

  /// Deletes a profile from the database
  Future deleteProfile({@required Profile profile});

  /// Deletes all profiles from the database
  Future deleteAllProfiles();

  /// Gets the token
  Future getToken();
}
