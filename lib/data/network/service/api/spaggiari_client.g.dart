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
  getLessonBetweenDates(studentId, start, end) async {
    ArgumentError.checkNotNull(studentId, 'studentId');
    ArgumentError.checkNotNull(start, 'start');
    ArgumentError.checkNotNull(end, 'end');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/students/$studentId/lessons/$start/$end',
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

  @override
  getGrades(studentId) async {
    ArgumentError.checkNotNull(studentId, 'studentId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/students/$studentId/grades',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = GradesResponse.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  getAgenda(studentId, start, end) async {
    ArgumentError.checkNotNull(studentId, 'studentId');
    ArgumentError.checkNotNull(start, 'start');
    ArgumentError.checkNotNull(end, 'end');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/students/$studentId/agenda/all/$start/$end',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = AgendaResponse.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  getAbsences(studentId) async {
    ArgumentError.checkNotNull(studentId, 'studentId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/students/$studentId/absences/details',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = AbsencesResponse.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  getPeriods(studentId) async {
    ArgumentError.checkNotNull(studentId, 'studentId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/students/$studentId/periods',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = PeriodsResponse.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  getNoticeBoard(studentId) async {
    ArgumentError.checkNotNull(studentId, 'studentId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/students/$studentId/noticeboard',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = NoticeboardResponse.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  readNotice(studentId, eventCode, pubId, body) async {
    ArgumentError.checkNotNull(studentId, 'studentId');
    ArgumentError.checkNotNull(eventCode, 'eventCode');
    ArgumentError.checkNotNull(pubId, 'pubId');
    ArgumentError.checkNotNull(body, 'body');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = body;
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/students/$studentId/noticeboard/read/$eventCode/$pubId/101',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = NoticeboardReadResponse.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  getNotice(studentId, eventCode, pubId, attachNum) async {
    ArgumentError.checkNotNull(studentId, 'studentId');
    ArgumentError.checkNotNull(eventCode, 'eventCode');
    ArgumentError.checkNotNull(pubId, 'pubId');
    ArgumentError.checkNotNull(attachNum, 'attachNum');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<List<dynamic>> _result = await _dio.request(
        '/students/$studentId/noticeboard/attach/$eventCode/$pubId/$attachNum',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl,
            responseType: ResponseType.bytes),
        data: _data);
    final value = _result.data.cast<int>();
    return Future.value(value);
  }

  @override
  getNotes(studentId) async {
    ArgumentError.checkNotNull(studentId, 'studentId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/students/$studentId/notes/all/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = NotesResponse.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  markNote(studentId, type, note, body) async {
    ArgumentError.checkNotNull(studentId, 'studentId');
    ArgumentError.checkNotNull(type, 'type');
    ArgumentError.checkNotNull(note, 'note');
    ArgumentError.checkNotNull(body, 'body');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = body;
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/students/$studentId/notes/$type/read/$note',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = NotesReadResponse.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  getDidactics(studentId) async {
    ArgumentError.checkNotNull(studentId, 'studentId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/students/$studentId/didactics',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = DidacticsResponse.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  getAttachmentUrl(studentId, fileId) async {
    ArgumentError.checkNotNull(studentId, 'studentId');
    ArgumentError.checkNotNull(fileId, 'fileId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/students/$studentId/didactics/item/$fileId',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = DownloadAttachmentURLResponse.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  getAttachmentText(studentId, fileId) async {
    ArgumentError.checkNotNull(studentId, 'studentId');
    ArgumentError.checkNotNull(fileId, 'fileId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/students/$studentId/didactics/item/$fileId',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = DownloadAttachmentTextResponse.fromJson(_result.data);
    return Future.value(value);
  }
}
