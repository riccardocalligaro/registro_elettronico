import 'package:dartz/dartz.dart';
import 'package:dartz/dartz_streaming.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:registro_elettronico/component/api_config.dart';
import 'package:registro_elettronico/core/error/failures.dart';
import 'package:registro_elettronico/domain/entity/api_requests/login_request.dart';
import 'package:registro_elettronico/domain/entity/api_responses/absences_response.dart';
import 'package:registro_elettronico/domain/entity/api_responses/agenda_response.dart';
import 'package:registro_elettronico/domain/entity/api_responses/didactics_response.dart';
import 'package:registro_elettronico/domain/entity/api_responses/documents_response.dart';
import 'package:registro_elettronico/domain/entity/api_responses/grades_response.dart';
import 'package:registro_elettronico/domain/entity/api_responses/lessons_response.dart';
import 'package:registro_elettronico/domain/entity/api_responses/login_response.dart';
import 'package:registro_elettronico/domain/entity/api_responses/notes_response.dart';
import 'package:registro_elettronico/domain/entity/api_responses/noticeboard_read_response.dart';
import 'package:registro_elettronico/domain/entity/api_responses/noticeboard_response.dart';
import 'package:registro_elettronico/domain/entity/api_responses/parent_response.dart';
import 'package:registro_elettronico/domain/entity/api_responses/periods_response.dart';
import 'package:registro_elettronico/domain/entity/api_responses/subjects_response.dart';
import 'package:registro_elettronico/domain/entity/api_responses/notes_read_response.dart';

import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

// part 'spaggiari_client.g.dart';

@RestApi(baseUrl: '${ApiConfig.BASE_API_URL}')
abstract class SpaggiariClient {
  factory SpaggiariClient(Dio dio) = _SpaggiariClient;

  /// Log in path
  @POST("/auth/login")
  Future<Either<LoginResponse, ParentsLoginResponse>> loginUser(
      @Body() LoginRequest loginRequest);

  /// Gets lesson of today
  @GET("/students/{studentId}/lessons/today")
  Future<LessonsResponse> getTodayLessons(@Path() String studentId);

  /// Gets lesson between date 1 and date 2
  @GET("/students/{studentId}/lessons/{start}/{end}")
  Future<LessonsResponse> getLessonBetweenDates(@Path() String studentId,
      @Path("start") String start, @Path("end") String end);

  // Subjects
  @GET("/students/{studentId}/subjects")
  Future<SubjectsResponse> getSubjects(@Path() String studentId);

  // Subjects
  @GET("/students/{studentId}/grades")
  Future<GradesResponse> getGrades(@Path() String studentId);

  // Subjects
  @GET("/students/{studentId}/agenda/all/{start}/{end}")
  Future<AgendaResponse> getAgenda(@Path() String studentId,
      @Path("start") String start, @Path("end") String end);

  // Absences
  @GET("/students/{studentId}/absences/details")
  Future<AbsencesResponse> getAbsences(@Path() String studentId);

  // Absences
  @GET("/students/{studentId}/periods")
  Future<PeriodsResponse> getPeriods(@Path() String studentId);

  // Notice board
  @GET("/students/{studentId}/noticeboard")
  Future<NoticeboardResponse> getNoticeBoard(@Path() String studentId);

  // Notice board
  @POST("/students/{studentId}/noticeboard/read/{eventCode}/{pubId}/101")
  Future<NoticeboardReadResponse> readNotice(
    @Path('studentId') String studentId,
    @Path('eventCode') String eventCode,
    @Path('pubId') String pubId,
    @Body() String body,
  );

  /// After the post request to read the notice you can get the attachment
  @GET(
      "/students/{studentId}/noticeboard/attach/{eventCode}/{pubId}/{attachNumber}")
  @DioResponseType(ResponseType.bytes)
  Future<List<int>> getNotice(
    @Path('studentId') String studentId,
    @Path('eventCode') String eventCode,
    @Path('pubId') String pubId,
    @Path('attachNumber') String attachNum,
  );

  @GET("/students/{studentId}/notes/all/")
  Future<NotesResponse> getNotes(@Path() String studentId);

  @POST("/students/{studentId}/notes/{type}/read/{layout_note}")
  Future<NotesReadResponse> markNote(
    @Path('studentId') String studentId,
    @Path("type") String type,
    @Path("layout_note") int note,
    @Body() String body,
  );

  @GET("/students/{studentId}/didactics")
  Future<DidacticsResponse> getDidactics(@Path() String studentId);

  @GET("/students/{studentId}/didactics/item/{fileId}")
  Future<DownloadAttachmentURLResponse> getAttachmentUrl(
      @Path() String studentId, @Path("fileId") int fileId);

  @GET("/students/{studentId}/didactics/item/{fileId}")
  Future<DownloadAttachmentTextResponse> getAttachmentText(
      @Path() String studentId, @Path("fileId") int fileId);

  @POST('/students/{studentId}/documents')
  Future<DocumentsResponse> getDocuments(@Path() String studentId);

  @POST('/students/{studentId}/documents/check/{documentHash}')
  Future<bool> checkDocumentAvailability(
    @Path() String studentId,
    @Path() String documentHash,
  );

  @POST('/students/{studentId}/documents/check/{documentHash}')
  Future<Tuple2<List<int>, String>> readDocument(
    @Path() String studentId,
    @Path() String documentHash,
  );
}

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

    if (_result.statusCode == 200 &&
        _result.data.containsKey('requestedAction')) {
      return Right(ParentsLoginResponse.fromJson(_result.data));
    }

    return Left(LoginResponse.fromJson(_result.data));

    //return Future.value(value);
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

  @override
  Future<DocumentsResponse> getDocuments(String studentId) async {
    ArgumentError.checkNotNull(studentId, 'studentId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = '';
    final Response<Map<String, dynamic>> _result = await _dio.request(
      '/students/$studentId/documents',
      queryParameters: queryParameters,
      options: RequestOptions(
          method: 'POST',
          headers: <String, dynamic>{},
          extra: _extra,
          baseUrl: baseUrl),
      data: _data,
    );
    final value = DocumentsResponse.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  Future<bool> checkDocumentAvailability(
      String studentId, String documentHash) async {
    ArgumentError.checkNotNull(studentId, 'studentId');
    ArgumentError.checkNotNull(documentHash, 'documentHash');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = '';
    final Response<Map<String, dynamic>> _result = await _dio.request(
      '/students/$studentId/documents/check/$documentHash',
      queryParameters: queryParameters,
      options: RequestOptions(
        method: 'POST',
        headers: <String, dynamic>{},
        extra: _extra,
        baseUrl: baseUrl,
      ),
      data: _data,
    );

    final bool avaliable = _result.data['document']['available'];
    return Future.value(avaliable);
  }

  @override
  Future<Tuple2<List<int>, String>> readDocument(
    String studentId,
    String documentHash,
  ) async {
    ArgumentError.checkNotNull(studentId, 'studentId');
    ArgumentError.checkNotNull(documentHash, 'documentHash');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = '';
    final Response<List<dynamic>> _result = await _dio.request(
      '/students/$studentId/documents/read/$documentHash',
      queryParameters: queryParameters,
      options: RequestOptions(
        method: 'POST',
        headers: <String, dynamic>{},
        extra: _extra,
        baseUrl: baseUrl,
        responseType: ResponseType.bytes,
      ),
      data: _data,
    );
    final bytes = _result.data.cast<int>();

    String filename = _result.headers.value('content-disposition') ?? "";
    filename = filename.replaceAll('attachment; filename=', '');
    filename = filename.replaceAll(RegExp('\"'), '');
    filename = filename.trim();
    return Tuple2(bytes, filename);
  }
}
