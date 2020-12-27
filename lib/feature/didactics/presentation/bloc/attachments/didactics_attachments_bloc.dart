import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:registro_elettronico/core/error/failures.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/didactics/data/model/didactics_remote_models.dart';
import 'package:registro_elettronico/feature/didactics/domain/repository/didactics_repository.dart';

part 'didactics_attachments_event.dart';

part 'didactics_attachments_state.dart';

class DidacticsAttachmentsBloc
    extends Bloc<DidacticsAttachmentsEvent, DidacticsAttachmentsState> {
  final DidacticsRepository didacticsRepository;

  DidacticsAttachmentsBloc({
    @required this.didacticsRepository,
  }) : super(DidacticsAttachmentsInitial());

  Future<DownloadAttachmentTextResponse> getTextAttachment(int fileId) =>
      didacticsRepository.getTextAtachment(fileId);

  Future<DownloadAttachmentURLResponse> getUrlAttachment(int fileId) =>
      didacticsRepository.getURLAtachment(fileId);

  @override
  Stream<DidacticsAttachmentsState> mapEventToState(
    DidacticsAttachmentsEvent event,
  ) async* {
    if (event is GetAttachment) {
      final content = event.content;
      final file =
          await didacticsRepository.getDownloadedFileFromContentId(content.id);

      if (file != null) {
        FLog.info(text: 'File exists ${file.path}');
        yield DidacticsAttachmentsFileLoaded(path: file.path);
      } else {
        yield DidacticsAttachmentsLoading();
        if (content.type == 'file') {
          try {
            final response =
                await didacticsRepository.getFileAttachment(content.id);
            FLog.info(
                text: 'Got response from Spaggiari of file ${content.id}');
            String filename =
                response.headers.value('content-disposition') ?? "";
            filename = filename.replaceAll('attachment; filename=', '');
            filename = filename.replaceAll(RegExp('\"'), '');
            filename = filename.trim();
            FLog.info(text: 'Filename -> $filename');
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
          } on NotConntectedException catch (_) {
            yield DidacticsAttachmentsErrorNotConnected();
          } catch (e, s) {
            FirebaseCrashlytics.instance.recordError(e, s);
            yield DidacticsAttachmentsErrror(error: e.toString());
          }
        } else if (content.type == 'text') {
          try {
            final res = await didacticsRepository.getTextAtachment(content.id);
            yield DidacticsAttachmentsTextLoaded(text: res.text);
          } on DidacticsAttachmentsErrorNotConnected {
            yield DidacticsAttachmentsErrorNotConnected();
          } catch (e) {
            yield DidacticsAttachmentsErrror(error: e.toString());
          }
        } else if (content.type == 'link') {
          try {
            final res = await didacticsRepository.getURLAtachment(content.id);
            yield DidacticsAttachmentsURLLoaded(url: res.item.link);
          } on DidacticsAttachmentsErrorNotConnected {
            yield DidacticsAttachmentsErrorNotConnected();
          } catch (e) {
            yield DidacticsAttachmentsErrror(error: e.toString());
          }
        } else {
          FirebaseCrashlytics.instance
              .log('Unknown file type ${file.contentId}');
          FLog.error(
            text:
                'Unknown file type ${file.contentId} - File name: ${file.name} - Content type: ${content.type}',
          );

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
