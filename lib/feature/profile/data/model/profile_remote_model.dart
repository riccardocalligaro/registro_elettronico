import 'dart:convert';

class ProfileRemoteModel {
  String ident;
  String firstName;
  String lastName;
  String token;
  String release;
  String expire;

  ProfileRemoteModel({
    this.ident,
    this.firstName,
    this.lastName,
    this.token,
    this.release,
    this.expire,
  });

  ProfileRemoteModel copyWith({
    String ident,
    String firstName,
    String lastName,
    String token,
    String release,
    String expire,
  }) {
    return ProfileRemoteModel(
      ident: ident ?? this.ident,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      token: token ?? this.token,
      release: release ?? this.release,
      expire: expire ?? this.expire,
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
    };
  }

  factory ProfileRemoteModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ProfileRemoteModel(
      ident: map['ident'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      token: map['token'],
      release: map['release'],
      expire: map['expire'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfileRemoteModel.fromJson(String source) =>
      ProfileRemoteModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProfileRemoteModel(ident: $ident, firstName: $firstName, lastName: $lastName, token: $token, release: $release, expire: $expire)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ProfileRemoteModel &&
        o.ident == ident &&
        o.firstName == firstName &&
        o.lastName == lastName &&
        o.token == token &&
        o.release == release &&
        o.expire == expire;
  }

  @override
  int get hashCode {
    return ident.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        token.hashCode ^
        release.hashCode ^
        expire.hashCode;
  }
}
