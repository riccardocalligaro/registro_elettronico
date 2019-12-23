import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
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
      try {
        final response = await noticesRepository.downloadFile(
          pubId: event.notice.pubId,
          eventCode: event.notice.eventCode,
          attachNumber: 1,
        );
        print(response.toString());
        final path = await _localPath;
        final filePath =
            '$path/${event.notice.contentTitle.replaceAll(' ', '_')}';
        File file = File(filePath);
        var raf = file.openSync(mode: FileMode.write);
        raf.writeFromSync(response);
        await raf.close();
        yield AttachmentDownloadLoaded(filePath);
      } on DioError catch (e) {
        yield AttachmentDownloadError(e.toString());
      } catch (e) {
        yield AttachmentDownloadError(e.toString());
      }

      yield AttachmentDownloadLoaded('');
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}
