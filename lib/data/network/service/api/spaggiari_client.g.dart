// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spaggiari_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _SpaggiariClient implements SpaggiariClient {
  _SpaggiariClient(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    this.baseUrl ??= 'https://web.spaggiari.eu/rest/v1';
  }

  final Dio _dio;

  String baseUrl;

  @override
  loginUser(loginRequest) async {
    ArgumentError.checkNotNull(loginRequest, 'loginRequest');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(loginRequest.toJson() ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/auth/login',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = LoginResponse.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  getTodayLessons(studentId) async {
    ArgumentError.checkNotNull(studentId, 'studentId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/students/$studentId/lessons/today',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = LessonsResponse.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  getSubjects(studentId) async {
    ArgumentError.checkNotNull(studentId, 'studentId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/students/$studentId/subjects',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = SubjectsResponse.fromJson(_result.data);
    return Future.value(value);
  }
}
