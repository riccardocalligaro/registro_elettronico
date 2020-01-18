import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

@JsonSerializable()
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

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}
