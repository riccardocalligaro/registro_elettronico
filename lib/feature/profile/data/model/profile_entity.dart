import 'dart:convert';

import 'package:flutter/material.dart';

class Profile {
  String ident;
  String firstName;
  String lastName;
  String token;
  String release;
  String expire;
  String studentId;

  Profile({
    @required this.ident,
    @required this.firstName,
    @required this.lastName,
    @required this.token,
    @required this.release,
    @required this.expire,
    @required this.studentId,
  });

  Profile copyWith({
    String ident,
    String firstName,
    String lastName,
    String token,
    String release,
    String expire,
    String studentId,
  }) {
    return Profile(
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

  factory Profile.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Profile(
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

  factory Profile.fromJson(String source) =>
      Profile.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Profile(ident: $ident, firstName: $firstName, lastName: $lastName, token: $token, release: $release, expire: $expire, studentId: $studentId)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Profile &&
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
