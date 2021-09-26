import 'package:registro_elettronico/core/infrastructure/log/logger.dart';
import 'package:registro_elettronico/utils/constants/registro_constants.dart';

/// This is the class that is used when the reponse of the
/// client is a code different thatn 200, it converts the generic
/// dio error to a "spaggiari" error response
class ServerException implements Exception {
  int? statusCode;
  String? error;
  String? info;
  String? message;
  int? messageCode;

  ServerException({
    this.statusCode,
    this.error,
    this.info,
    this.message,
    this.messageCode,
  });

  ServerException.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    error = json['error'];
    info = json['info'];
    message = json['message'];
    messageCode =
        _tryToConvertMessageToConstant(json['statusCode'], json['message']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['error'] = this.error;
    data['info'] = this.info;
    data['message'] = this.message;
    return data;
  }

  int _tryToConvertMessageToConstant(int? code, String message) {
    Logger.info(code.toString() + " :" + message);
    if (code == 422 && message.trim() == "username and password does't match") {
      return RegistroConstants.USERNAME_PASSWORD_NOT_MATCHING;
    }
    return -1;
  }
}
