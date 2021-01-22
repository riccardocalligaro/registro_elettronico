class LoginResponse {
  String ident;
  String firstName;
  String lastName;
  String token;
  String release;
  String expire;

  LoginResponse({
    this.ident,
    this.firstName,
    this.lastName,
    this.token,
    this.release,
    this.expire,
  });

  LoginResponse.fromJson(Map<String, dynamic> json) {
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
}
