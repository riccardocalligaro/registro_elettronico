// ignore_for_file: always_declare_return_types

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:registro_elettronico/feature/notes/data/model/remote/note_remote_model.dart';
import 'package:registro_elettronico/feature/notes/data/model/remote/notes_read_remote_model.dart';
import 'package:registro_elettronico/feature/scrutini/data/model/document_remote_model.dart';

// part 'spaggiari_client.g.dart';

// This is written 'strangely' beacuse I used Retrofit to generate the calls but then
// for feature reasons I had to manually write the http calls

abstract class LegacySpaggiariClient {
  factory LegacySpaggiariClient(Dio dio) = _SpaggiariClient;

  Future<NotesResponse> getNotes(String studentId);

  Future<NotesReadResponse> markNote(
    String studentId,
    String type,
    int note,
    String body,
  );

  Future<DocumentsResponse> getDocuments(String? studentId);

  Future<bool> checkDocumentAvailability(
      String? studentId, String documentHash);

  Future<Tuple2<List<int>, String?>> readDocument(
    String? studentId,
    String documentHash,
  );
}

class _SpaggiariClient implements LegacySpaggiariClient {
  _SpaggiariClient(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    this.baseUrl ??= 'https://web.spaggiari.eu/rest/v1';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  getNotes(studentId) async {
    ArgumentError.checkNotNull(studentId, 'studentId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request(
      '$baseUrl/students/$studentId/notes/all/',
      queryParameters: queryParameters,
      options: Options(
        method: 'GET',
        headers: <String, dynamic>{},
        extra: _extra,
      ),
      data: _data,
    );
    final value = NotesResponse.fromJson(_result.data!);
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
      '$baseUrl/students/$studentId/notes/$type/read/$note',
      queryParameters: queryParameters,
      options: Options(
        method: 'POST',
        headers: <String, dynamic>{},
        extra: _extra,
      ),
      data: _data,
    );
    final value = NotesReadResponse.fromJson(_result.data!);
    return Future.value(value);
  }

  @override
  Future<DocumentsResponse> getDocuments(String? studentId) async {
    ArgumentError.checkNotNull(studentId, 'studentId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = '';
    final Response<Map<String, dynamic>> _result = await _dio.request(
      '$baseUrl/students/$studentId/documents',
      queryParameters: queryParameters,
      options: Options(
        method: 'POST',
        headers: <String, dynamic>{},
        extra: _extra,
      ),
      data: _data,
    );
    final value = DocumentsResponse.fromJson(_result.data!);
    return Future.value(value);
  }

  @override
  Future<bool> checkDocumentAvailability(
      String? studentId, String documentHash) async {
    ArgumentError.checkNotNull(studentId, 'studentId');
    ArgumentError.checkNotNull(documentHash, 'documentHash');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = '';
    final Response<Map<String, dynamic>> _result = await _dio.request(
      '$baseUrl/students/$studentId/documents/check/$documentHash',
      queryParameters: queryParameters,
      options: Options(
        method: 'POST',
        headers: <String, dynamic>{},
        extra: _extra,
      ),
      data: _data,
    );

    final bool? avaliable = _result.data!['document']['available'];
    return Future.value(avaliable);
  }

  @override
  Future<Tuple2<List<int>, String?>> readDocument(
    String? studentId,
    String documentHash,
  ) async {
    ArgumentError.checkNotNull(studentId, 'studentId');
    ArgumentError.checkNotNull(documentHash, 'documentHash');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = '';
    final Response<List<dynamic>> _result = await _dio.request(
      '$baseUrl/students/$studentId/documents/read/$documentHash',
      queryParameters: queryParameters,
      options: Options(
        method: 'POST',
        headers: <String, dynamic>{},
        extra: _extra,
        responseType: ResponseType.bytes,
      ),
      data: _data,
    );
    final bytes = _result.data!.cast<int>();

    String? filename = _result.headers.value('content-disposition');

    return Tuple2(bytes, filename);
  }
}
