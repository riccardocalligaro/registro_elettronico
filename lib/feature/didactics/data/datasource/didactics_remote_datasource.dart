import 'package:dio/dio.dart';
import 'package:registro_elettronico/feature/didactics/data/model/remote/attachment/text_content_remote_model.dart';
import 'package:registro_elettronico/feature/didactics/data/model/remote/attachment/url_content_remote_model.dart';
import 'package:registro_elettronico/feature/didactics/data/model/remote/teacher_remote_model.dart';
import 'package:registro_elettronico/feature/didactics/domain/model/content_domain_model.dart';

class DidacticsRemoteDatasource {
  final Dio? dio;

  DidacticsRemoteDatasource({
    required this.dio,
  });

  Future<List<TeacherRemoteModel>> getTeachersMaterials() async {
    final response = await dio!.get('/students/{studentId}/didactics');

    List<TeacherRemoteModel> teachers = List<TeacherRemoteModel>.from(
      response.data['didacticts'].map(
        (i) => TeacherRemoteModel.fromJson(i),
      ),
    );

    return teachers;
  }

  Future<Response> downloadFile({
    required ContentDomainModel content,
    required void Function(int, int) onProgress,
    required String path,
  }) async {
    final file = await dio!.download(
      '/students/{studentId}/didactics/item/${content.id}',
      (Headers responseHeaders) {
        String filename = responseHeaders.value('content-disposition') ?? "";
        filename = filename.replaceAll('attachment; filename=', '');
        filename = filename.replaceAll(RegExp('\"'), '');
        filename = filename.trim();
        return '$path/$filename';
      },
      onReceiveProgress: (value1, value2) {
        onProgress(value1, value2);
      },
    );

    return file;
  }

  Future<URLContentRemoteModel> getURLContent({
    required int? fileId,
  }) async {
    final response =
        await dio!.get('/students/{studentId}/didactics/item/$fileId');

    return URLContentRemoteModel.fromJson(response.data);
  }

  Future<TextContentRemoteModel> getTextContent({
    required int? fileId,
  }) async {
    final response =
        await dio!.get('/students/{studentId}/didactics/item/$fileId');

    return TextContentRemoteModel.fromJson(response.data);
  }
}
