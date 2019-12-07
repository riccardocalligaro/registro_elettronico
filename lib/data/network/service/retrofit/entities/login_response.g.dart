// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) {
  return LoginResponse(
    ident: json['ident'] as String,
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    token: json['token'] as String,
    release: json['release'] as String,
    expire: json['expire'] as String,
  );
}

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'ident': instance.ident,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'token': instance.token,
      'release': instance.release,
      'expire': instance.expire,
    };
