import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:registro_elettronico/domain/repository/notices_repository.dart';
import './bloc.dart';

class AttachmentDownloadBloc
    extends Bloc<AttachmentDownloadEvent, AttachmentDownloadState> {
  NoticesRepository noticesRepository;

  AttachmentDownloadBloc(this.noticesRepository);

  @override
  AttachmentDownloadState get initialState => AttachmentDownloadInitial();

  @override
  Stream<AttachmentDownloadState> mapEventToState(
    AttachmentDownloadEvent event,
  ) async* {
    if (event is DownloadAttachment) {
      yield AttachmentDownloadLoading();
      FLog.info(text: 'Downloading attachment');
      try {
        final response = await noticesRepository.downloadFile(
          notice: event.notice,
          attachNumber: event.attachment.attachNumber,
        );

        FLog.info(text: 'Got response for file');

        final path = await _localPath;
        final ext = event.attachment.fileName.split('.').last;
        final filePath =
            '$path/${event.notice.contentTitle.replaceAll(' ', '_')}.$ext';

        File file = File(filePath);
        var raf = file.openSync(mode: FileMode.write);
        raf.writeFromSync(response);
        await raf.close();
        yield AttachmentDownloadLoaded(filePath);
      } on DioError catch (e) {
        yield AttachmentDownloadError(e.toString());
      } on Exception catch (e, s) {
        FLog.error(
          text: 'Error downloading attachment',
          exception: e,
          stacktrace: s,
        );
        yield AttachmentDownloadError(e.toString());
      }
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}
