/// This is the class that is used when the reponse of the
/// client is a code different thatn 200, it converts the generic
/// dio error to a "spaggiari" error response
class ServerException implements Exception {
  int statusCode;
  String error;
  String info;
  String message;

  ServerException({this.statusCode, this.error, this.info, this.message});

  ServerException.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    error = json['error'];
    info = json['info'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // TODO: add the translation of the message
    data['statusCode'] = this.statusCode;
    data['error'] = this.error;
    data['info'] = this.info;
    data['message'] = this.message;
    return data;
  }
}
