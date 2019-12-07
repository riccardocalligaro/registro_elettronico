// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) {
  return Profile(
    ident: json['ident'] as String,
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    token: json['token'] as String,
    release: json['release'] as String,
    expire: json['expire'] as String,
  );
}

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'ident': instance.ident,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'token': instance.token,
      'release': instance.release,
      'expire': instance.expire,
    };
