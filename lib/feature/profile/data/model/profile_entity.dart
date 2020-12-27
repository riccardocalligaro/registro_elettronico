import 'dart:convert';

class Profile {
  String ident;
  String firstName;
  String lastName;
  String token;
  String release;
  String expire;

  Profile({
    this.ident,
    this.firstName,
    this.lastName,
    this.token,
    this.release,
    this.expire,
  });

  Profile copyWith({
    String ident,
    String firstName,
    String lastName,
    String token,
    String release,
    String expire,
  }) {
    return Profile(
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

  factory Profile.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Profile(
      ident: map['ident'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      token: map['token'],
      release: map['release'],
      expire: map['expire'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Profile.fromJson(String source) =>
      Profile.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Profile(ident: $ident, firstName: $firstName, lastName: $lastName, token: $token, release: $release, expire: $expire)';
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
