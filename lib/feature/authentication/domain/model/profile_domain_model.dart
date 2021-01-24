import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/utils/profile_utils.dart';

class ProfileDomainModel {
  String ident;
  String firstName;
  String lastName;
  String token;
  DateTime release;
  DateTime expire;
  String studentId;

  ProfileDomainModel({
    @required this.ident,
    @required this.firstName,
    @required this.lastName,
    @required this.token,
    @required this.release,
    @required this.expire,
    @required this.studentId,
  });

  ProfileLocalModel toLocalModel() {
    return ProfileLocalModel(
      ident: this.ident,
      studentId: ProfileUtils.getIdFromIdent(this.ident),
      firstName: this.firstName ?? "",
      lastName: this.lastName ?? "",
      token: this.token ?? "",
      release: this.release ?? DateTime.now(),
      expire: this.expire ?? DateTime.now(),
      currentlyLoggedIn: true,
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
  }

  ProfileDomainModel copyWith({
    String ident,
    String firstName,
    String lastName,
    String token,
    String release,
    String expire,
    String studentId,
  }) {
    return ProfileDomainModel(
      ident: ident ?? this.ident,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      token: token ?? this.token,
      release: release ?? this.release,
      expire: expire ?? this.expire,
      studentId: studentId ?? this.studentId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ident': ident,
      'firstName': firstName,
      'lastName': lastName,
      'token': token,
      'release': release,
      'expire': expire,
      'studentId': studentId,
    };
  }

  factory ProfileDomainModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ProfileDomainModel(
      ident: map['ident'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      token: map['token'],
      release: map['release'],
      expire: map['expire'],
      studentId: map['studentId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfileDomainModel.fromJson(String source) =>
      ProfileDomainModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Profile(ident: $ident, firstName: $firstName, lastName: $lastName, token: $token, release: $release, expire: $expire, studentId: $studentId)';
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
        o.studentId == studentId;
  }

  @override
  int get hashCode {
    return ident.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        token.hashCode ^
        release.hashCode ^
        expire.hashCode ^
        studentId.hashCode;
  }
}
