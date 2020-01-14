import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:f_logs/f_logs.dart';
import 'package:flutter/material.dart';

abstract class WebSpaggiariClient {
  Future<String> getPHPToken({
    @required String username,
    @required String password,
  });
}

class WebSpaggiariClientImpl implements WebSpaggiariClient {
  Dio _dio;

  WebSpaggiariClientImpl(this._dio);

  @override
  Future<String> getPHPToken({String username, String password}) async {
    final loginPage =
        'https://web.spaggiari.eu/auth-p7/app/default/AuthApi4.php?a=aLoginPwd';

    Map<String, String> bodyParams = new Map();
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
      //final key = _result.headers.map.keys.where(test);
      //return _result.headers.map[key].single;
      final key =
          _result.headers.map.keys.where((k) => k == 'set-cookie').single;
      var cj = new CookieJar();
      //Save cookies
      final ssid = _result.headers.map[key].elementAt(0);
      List<Cookie> cookies = [new Cookie("PHPSESSID", ssid.split(';')[0])];
      cj.saveFromResponse(Uri.parse("https://web.spaggiari.eu/"), cookies);
      return ssid;
    } else {
      FLog.info(text: 'Erorr');
    }
  }
}
