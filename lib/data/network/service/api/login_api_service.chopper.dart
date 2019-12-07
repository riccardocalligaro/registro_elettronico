// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

class _$LoginApiService extends LoginApiService {
  _$LoginApiService([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  final definitionType = LoginApiService;

  Future<Response> postLogin(Map<String, dynamic> body) {
    final $url = '/auth/login';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }
}
