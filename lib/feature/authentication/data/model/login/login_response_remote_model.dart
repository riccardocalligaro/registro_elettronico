import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:registro_elettronico/utils/profile_utils.dart';

class DefaultLoginResponseRemoteModel {
  String ident;
  String firstName;
  String lastName;
  String token;
  String release;
  String expire;

  DefaultLoginResponseRemoteModel({
    @required this.ident,
    @required this.firstName,
    @required this.lastName,
    @required this.token,
    @required this.release,
    @required this.expire,
  });

  ProfileLocalModel toLocalModel() {
    return ProfileLocalModel(
      ident: this.ident,
      studentId: ProfileUtils.getIdFromIdent(this.ident),
      firstName: this.firstName ?? "",
      lastName: this.lastName ?? "",
      token: this.token ?? "",
      release: DateTime.parse(this.release) ?? DateTime.now(),
      expire: DateTime.parse(this.expire) ?? DateTime.now(),
      currentlyLoggedIn: true,
    );
  }

  DefaultLoginResponseRemoteModel.fromJson(Map<String, dynamic> json) {
    ident = json['ident'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    token = json['token'];
    release = json['release'];
    expire = json['expire'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['ident'] = this.ident;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['token'] = this.token;
    data['release'] = this.release;
    data['expire'] = this.expire;
    return data;
  }

  @override
  String toString() {
    return 'DefaultLoginResponseRemoteModel(ident: $ident, firstName: $firstName, lastName: $lastName, token: $token, release: $release, expire: $expire)';
  }
}
