class LoginToken {
  String token;

  static final LoginToken _inst = LoginToken._internal();

  LoginToken._internal();

  factory LoginToken(String token) {
    _inst.token = token;
    return _inst;
  }
}
