import 'package:dio/dio.dart';
import 'package:fimber/fimber.dart';
import 'package:registro_elettronico/core/data/remote/web/web_spaggiari_client.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures.dart';
import 'package:registro_elettronico/core/infrastructure/log/logger.dart';

class WebSpaggiariClientImpl implements WebSpaggiariClient {
  Dio _dio;

  WebSpaggiariClientImpl(this._dio);

  @override
  Future<String> getPHPToken({
    required String username,
    required String password,
    bool? lastYear,
  }) async {
    Fimber.i('Requesting new PHP Token');

    String loginPage;
    if (lastYear ?? false) {
      loginPage =
          'https://web18.spaggiari.eu/auth-p7/app/default/AuthApi4.php?a=aLoginPwd';
    } else {
      loginPage =
          'https://web.spaggiari.eu/auth-p7/app/default/AuthApi4.php?a=aLoginPwd';
    }

    Map<String, String> bodyParams = Map();
    bodyParams["uid"] = username;
    bodyParams["pwd"] = password;

    final Response<Map<String, dynamic>> _result = await _dio.request(
      loginPage,
      options: Options(
        method: 'POST',
        contentType: Headers.formUrlEncodedContentType,
      ),
      data: bodyParams,
    );

    if (_result.headers.map.containsKey('set-cookie')) {
      final key =
          _result.headers.map.keys.where((k) => k == 'set-cookie').single;
      final ssid = _result.headers.map[key]?.elementAt(1);

      return ssid!;
    } else {
      throw GenericFailure();
    }
  }
}
