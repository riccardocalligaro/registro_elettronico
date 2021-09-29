import 'dart:convert';

import 'package:registro_elettronico/feature/authentication/data/model/profile_local_model.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:registro_elettronico/utils/profile_utils.dart';

class ProfileDomainModel {
  String? ident;
  String? firstName;
  String? lastName;
  String? token;
  DateTime? release;
  DateTime? expire;
  String? studentId;
  bool? currentlyLoggedIn;
  String? dbName;

  ProfileDomainModel({
    required this.ident,
    required this.firstName,
    required this.lastName,
    required this.token,
    required this.release,
    required this.expire,
    required this.studentId,
    required this.currentlyLoggedIn,
    required this.dbName,
  });

  ProfileLocalModel toLocalModel() {
    return ProfileLocalModel(
      ident: this.ident,
      studentId: ProfileUtils.getIdFromIdent(this.ident!),
      firstName: this.firstName ?? "",
      lastName: this.lastName ?? "",
      token: this.token ?? "",
      release: this.release ?? DateTime.now(),
      expire: this.expire ?? DateTime.now(),
      currentlyLoggedIn: this.currentlyLoggedIn ?? true,
      dbName: this.dbName ?? PrefsConstants.databaseNameBeforeMigration,
    );
  }

  ProfileDomainModel.fromLocalModel(ProfileLocalModel l) {
    this.ident = l.ident;
    this.firstName = l.firstName;
    this.lastName = l.lastName;
    this.token = l.token;
    this.release = l.release;
    this.expire = l.expire;
    this.studentId = l.studentId;
    this.currentlyLoggedIn = l.currentlyLoggedIn;
    this.dbName = l.dbName;
  }

  ProfileDomainModel copyWith({
    String? ident,
    String? firstName,
    String? lastName,
    String? token,
    DateTime? release,
    DateTime? expire,
    String? studentId,
    bool? currentlyLoggedIn,
    String? dbName,
  }) {
    return ProfileDomainModel(
      ident: ident ?? this.ident,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      token: token ?? this.token,
      release: release ?? this.release,
      expire: expire ?? this.expire,
      studentId: studentId ?? this.studentId,
      currentlyLoggedIn: currentlyLoggedIn ?? this.currentlyLoggedIn,
      dbName: dbName ?? this.dbName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ident': ident,
      'firstName': firstName,
      'lastName': lastName,
      'token': token,
      'release': release?.millisecondsSinceEpoch,
      'expire': expire?.millisecondsSinceEpoch,
      'studentId': studentId,
      'currentlyLoggedIn': currentlyLoggedIn,
      'dbName': dbName,
    };
  }

  static ProfileDomainModel? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;

    return ProfileDomainModel(
      ident: map['ident'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      token: map['token'],
      release: DateTime.parse(map['release']),
      expire: DateTime.parse(map['expire']),
      studentId: map['studentId'],
      currentlyLoggedIn: map['currentlyLoggedIn'] ?? true,
      dbName: map['dbName'] ?? PrefsConstants.databaseNameBeforeMigration,
    );
  }

  String toJson() => json.encode(toMap());

  static ProfileDomainModel? fromJson(String source) =>
      ProfileDomainModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProfileDomainModel(ident: $ident, firstName: $firstName, lastName: $lastName, token: $token, release: $release, expire: $expire, studentId: $studentId, currentlyLoggedIn: $currentlyLoggedIn, dbName: $dbName)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ProfileDomainModel &&
        o.ident == ident &&
        o.firstName == firstName &&
        o.lastName == lastName &&
        o.token == token &&
        o.release == release &&
        o.expire == expire &&
        o.studentId == studentId &&
        o.currentlyLoggedIn == currentlyLoggedIn &&
        o.dbName == dbName;
  }

  @override
  int get hashCode {
    return ident.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        token.hashCode ^
        release.hashCode ^
        expire.hashCode ^
        studentId.hashCode ^
        currentlyLoggedIn.hashCode ^
        dbName.hashCode;
  }
}
