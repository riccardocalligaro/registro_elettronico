import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/domain/entity/api_responses/didactics_response.dart';
import 'package:registro_elettronico/domain/repository/didactics_repository.dart';
import './bloc.dart';

class DidacticsAttachmentsBloc
    extends Bloc<DidacticsAttachmentsEvent, DidacticsAttachmentsState> {
  DidacticsRepository didacticsRepository;

  DidacticsAttachmentsBloc(this.didacticsRepository);

  Future<DownloadAttachmentTextResponse> getTextAttachment(int fileId) =>
      didacticsRepository.getTextAtachment(fileId);
  Future<DownloadAttachmentURLResponse> getUrlAttachment(int fileId) =>
      didacticsRepository.getURLAtachment(fileId);

  @override
  DidacticsAttachmentsState get initialState => DidacticsAttachmentsInitial();

  @override
  Stream<DidacticsAttachmentsState> mapEventToState(
    DidacticsAttachmentsEvent event,
  ) async* {
    if (event is GetAttachment) {
      Logger log = Logger();
      final content = event.content;
      final file =
          await didacticsRepository.getDownloadedFileFromContentId(content.id);

      if (file != null) {
        log.i('File exists ${file.path}');
        yield DidacticsAttachmentsFileLoaded(path: file.path);
      } else {
        yield DidacticsAttachmentsLoading();
        if (content.type == 'file') {
          try {
            Logger log = Logger();
            final response =
                await didacticsRepository.getFileAttachment(content.id);
            log.i("Got response from Spaggiari of file ${content.id}");
            String filename =
                response.headers.value('content-disposition') ?? "";
            filename = filename.replaceAll('attachment; filename=', '');
            filename = filename.replaceAll(RegExp('\"'), '');
            filename = filename.trim();
            log.i("filename -> $filename");
            final path = await _localPath;
            String filePath = '$path/$filename';
            File file = File(filePath);
            var raf = file.openSync(mode: FileMode.write);
            raf.writeFromSync(response.data);
            await raf.close();
            await didacticsRepository
                .insertDownloadedFile(DidacticsDownloadedFile(
              path: filePath,
              name: content.name,
              contentId: content.id,
            ));
            yield DidacticsAttachmentsFileLoaded(path: filePath);
          } catch (e) {
            yield DidacticsAttachmentsErrror(error: e.toString());
          }
        } else if (content.type == 'text') {
          final res = await didacticsRepository.getTextAtachment(content.id);
          yield DidacticsAttachmentsTextLoaded(text: res.text);
        } else if (content.type == 'link') {
          final res = await didacticsRepository.getURLAtachment(content.id);
          yield DidacticsAttachmentsURLLoaded(url: res.item);
        } else {
          yield DidacticsAttachmentsErrror(error: 'Unknown file type');
        }
      }
    }

    if (event is DeleteAttachment) {
      final fileDb = await didacticsRepository
          .getDownloadedFileFromContentId(event.content.id);
      if (fileDb != null) {
        File file = File(fileDb.path);
        file.deleteSync();
        didacticsRepository.deleteDownloadedFile(fileDb);
      }
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}