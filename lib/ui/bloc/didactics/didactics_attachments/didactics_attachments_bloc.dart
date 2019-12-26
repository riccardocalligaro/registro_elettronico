import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
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
      yield DidacticsAttachmentsLoading();
      final content = event.content;

      if (content.type == 'file') {
        Logger log = Logger();
        final response =
            await didacticsRepository.getFileAttachment(content.id);
        log.i("Got response from Spaggiari of file ${content.id}");
        // final ext = .fileName.split('.').last;
        final path = await _localPath;
        String filePath;
        if (content.name.length > 0) {
          filePath = '$path/${content.name.replaceAll(' ', '_')}';
        } else {
          final name = content.date.millisecondsSinceEpoch.toString() +
              content.folderId.toString();
          filePath = '$path/${name.replaceAll(' ', '_')}';
        }
        
        File file = File(filePath);
        var raf = file.openSync(mode: FileMode.write);
        raf.writeFromSync(response);
        await raf.close();
        yield DidacticsAttachmentsFileLoaded(path: filePath);
      } else if (content.type == 'text') {
        final res = await didacticsRepository.getTextAtachment(content.id);
        yield DidacticsAttachmentsTextLoaded(text: res.text);
      } else if (content.type == 'link') {
        final res = await didacticsRepository.getURLAtachment(content.id);
        yield DidacticsAttachmentsURLLoaded(url: res.item);
      } else {
        yield DidacticsAttachmentsErrror(error: 'Uknown file type');
      }
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}
