import 'dart:convert';

class LoginRequestDomainModel {
  String? ident;
  String? pass;
  String? uid;

  LoginRequestDomainModel({
    required this.ident,
    required this.pass,
    required this.uid,
  });

  LoginRequestDomainModel copyWith({
    String? ident,
    String? pass,
    String? uid,
  }) {
    return LoginRequestDomainModel(
      ident: ident ?? this.ident,
      pass: pass ?? this.pass,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ident': ident,
      'pass': pass,
      'uid': uid,
    };
  }

  static LoginRequestDomainModel? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;

    return LoginRequestDomainModel(
      ident: map['ident'],
      pass: map['pass'],
      uid: map['uid'],
    );
  }

  String toJson() => json.encode(toMap());

  static LoginRequestDomainModel? fromJson(String source) =>
      LoginRequestDomainModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'LoginRequestDomainModel(ident: $ident, pass: $pass, uid: $uid)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is LoginRequestDomainModel &&
        o.ident == ident &&
        o.pass == pass &&
        o.uid == uid;
  }

  @override
  int get hashCode => ident.hashCode ^ pass.hashCode ^ uid.hashCode;
}
