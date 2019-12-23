import 'dart:async';
import 'package:bloc/bloc.dart';
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
      await Future.delayed(Duration(seconds: 1));
      yield AttachmentDownloadLoaded('');
    }
  }
}
