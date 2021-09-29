import 'dart:convert';

import 'package:registro_elettronico/feature/authentication/domain/model/profile_domain_model.dart';

class CredentialsDomainModel {
  ProfileDomainModel? profile;
  String? password;

  CredentialsDomainModel({
    required this.profile,
    required this.password,
  });

  CredentialsDomainModel copyWith({
    ProfileDomainModel? profile,
    String? password,
  }) {
    return CredentialsDomainModel(
      profile: profile ?? this.profile,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'profile': profile?.toMap(),
      'password': password,
    };
  }

  static CredentialsDomainModel? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;

    return CredentialsDomainModel(
      profile: ProfileDomainModel.fromMap(map['profile']),
      password: map['password'],
    );
  }

  String toJson() => json.encode(toMap());

  static CredentialsDomainModel? fromJson(String source) =>
      CredentialsDomainModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'CredentialsDomainModel(profile: $profile, password: $password)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is CredentialsDomainModel &&
        o.profile == profile &&
        o.password == password;
  }

  @override
  int get hashCode => profile.hashCode ^ password.hashCode;
}
