import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:registro_elettronico/core/error/failures.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/feature/noticeboard/domain/repository/notices_repository.dart';

part 'attachment_download_event.dart';

part 'attachment_download_state.dart';

class AttachmentDownloadBloc
    extends Bloc<AttachmentDownloadEvent, AttachmentDownloadState> {
  final NoticesRepository noticesRepository;

  AttachmentDownloadBloc({
    @required this.noticesRepository,
  }) : super(AttachmentDownloadInitial());

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

        FLog.info(text: 'Path $path');
        final ext = event.attachment.fileName.split('.').last;
        final filePath =
            '$path/${event.notice.contentTitle.replaceAll('/', '').replaceAll(' ', '_')}.$ext';

        File file = File(filePath);
        var raf = file.openSync(mode: FileMode.write);
        raf.writeFromSync(response);
        await raf.close();
        yield AttachmentDownloadLoaded(filePath);
      } on NotConntectedException {
        yield AttachmentDownloadLoadNotConnected();
      } on DioError catch (e) {
        yield AttachmentDownloadError(e.toString());
      } catch (e, s) {
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
