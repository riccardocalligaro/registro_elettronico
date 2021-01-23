import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:registro_elettronico/feature/noticeboard/data/model/notice/notice_remote_model.dart';
import 'package:registro_elettronico/feature/noticeboard/domain/model/attachment_domain_model.dart';
import 'package:registro_elettronico/feature/noticeboard/domain/model/notice_domain_model.dart';

class NoticeboardRemoteDatasource {
  final Dio dio;

  NoticeboardRemoteDatasource({
    @required this.dio,
  });

  Future<List<NoticeRemoteModel>> getNoticeboard() async {
    final response = await dio.get('/students/{studentId}/noticeboard');

    List<NoticeRemoteModel> notices = List<NoticeRemoteModel>.from(
      response.data['items'].map(
        (i) => NoticeRemoteModel.fromJson(i),
      ),
    );

    return notices;
  }

  Future<Response> readNotice(
    String eventCode,
    int pubId,
  ) async {
    final response = await dio
        .post('/students/{studentId}/noticeboard/read/$eventCode/$pubId/101');

    return response;
  }

  Future<Response> downloadNotice({
    @required NoticeDomainModel notice,
    @required AttachmentDomainModel attachment,
    @required String savePath,
    @required void Function(int, int) onProgress,
  }) async {
    final noticeDownload = await dio.download(
      '/students/{studentId}/noticeboard/attach/${notice.code}/${notice.id}/${attachment.attachNumber}',
      savePath,
      onReceiveProgress: (value1, value2) {
        onProgress(value1, value2);
      },
    );

    return noticeDownload;
  }
}
