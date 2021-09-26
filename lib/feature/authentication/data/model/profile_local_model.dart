import 'dart:convert';

import 'package:flutter/material.dart';

class ProfileLocalModel {
  final String? studentId;
  final String? ident;
  final String? firstName;
  final String? lastName;
  final String? token;
  final DateTime release;
  final DateTime expire;
  final bool? currentlyLoggedIn;
  final String? dbName;

  ProfileLocalModel({
    required this.studentId,
    required this.ident,
    required this.firstName,
    required this.lastName,
    required this.token,
    required this.release,
    required this.expire,
    required this.currentlyLoggedIn,
    required this.dbName,
  });

  ProfileLocalModel copyWith({
    String? studentId,
    String? ident,
    String? firstName,
    String? lastName,
    String? token,
    DateTime? release,
    DateTime? expire,
    bool? currentlyLoggedIn,
    String? dbName,
  }) {
    return ProfileLocalModel(
      studentId: studentId ?? this.studentId,
      ident: ident ?? this.ident,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      token: token ?? this.token,
      release: release ?? this.release,
      expire: expire ?? this.expire,
      currentlyLoggedIn: currentlyLoggedIn ?? this.currentlyLoggedIn,
      dbName: dbName ?? this.dbName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'ident': ident,
      'firstName': firstName,
      'lastName': lastName,
      'token': token,
      'release': release?.millisecondsSinceEpoch,
      'expire': expire?.millisecondsSinceEpoch,
      'currentlyLoggedIn': currentlyLoggedIn,
      'dbName': dbName,
    };
  }

  factory ProfileLocalModel.fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;

    return ProfileLocalModel(
      studentId: map['studentId'],
      ident: map['ident'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      token: map['token'],
      release: DateTime.fromMillisecondsSinceEpoch(map['release']),
      expire: DateTime.fromMillisecondsSinceEpoch(map['expire']),
      currentlyLoggedIn: map['currentlyLoggedIn'],
      dbName: map['dbName'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfileLocalModel.fromJson(Map<String, dynamic>? source) =>
      ProfileLocalModel.fromMap(source);

  @override
  String toString() {
    return 'ProfileLocalModel(studentId: $studentId, ident: $ident, firstName: $firstName, lastName: $lastName, token: $token, release: $release, expire: $expire, currentlyLoggedIn: $currentlyLoggedIn, dbName: $dbName)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ProfileLocalModel &&
        o.studentId == studentId &&
        o.ident == ident &&
        o.firstName == firstName &&
        o.lastName == lastName &&
        o.token == token &&
        o.release == release &&
        o.expire == expire &&
        o.currentlyLoggedIn == currentlyLoggedIn &&
        o.dbName == dbName;
  }

  @override
  int get hashCode {
    return studentId.hashCode ^
        ident.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        token.hashCode ^
        release.hashCode ^
        expire.hashCode ^
        currentlyLoggedIn.hashCode ^
        dbName.hashCode;
  }
}
