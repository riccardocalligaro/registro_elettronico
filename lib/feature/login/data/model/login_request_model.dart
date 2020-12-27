class LoginRequest {
  String ident;
  String pass;
  String uid;

  LoginRequest({this.ident, this.pass, this.uid});

  LoginRequest.fromJson(Map<String, dynamic> json) {
    ident = json['ident'];
    pass = json['pass'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['ident'] = this.ident;
    data['pass'] = this.pass;
    data['uid'] = this.uid;
    return data;
  }
}
