class LastYearToken {
  String? token;

  static final LastYearToken _inst = LastYearToken._internal();

  LastYearToken._internal();

  factory LastYearToken(String token) {
    _inst.token = token;
    return _inst;
  }
}
