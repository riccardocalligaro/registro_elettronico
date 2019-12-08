import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  String ident;
  String firstName;
  String lastName;
  String token;
  String release;
  String expire;

  LoginResponse(
      {this.ident,
      this.firstName,
      this.lastName,
      this.token,
      this.release,
      this.expire});

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
