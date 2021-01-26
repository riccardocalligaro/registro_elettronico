part of 'attachment_download_bloc.dart';

@immutable
abstract class AttachmentDownloadState {}

class AttachmentDownloadInitial extends AttachmentDownloadState {}

class AttachmentDownloadInProgress extends AttachmentDownloadState {
  final double percentage;

  AttachmentDownloadInProgress({
    @required this.percentage,
  });
}

class AttachmentDownloadSuccess extends AttachmentDownloadState {
  final AttachmentFile downloadedAttachment;

  AttachmentDownloadSuccess({
    @required this.downloadedAttachment,
  });
}

class AttachmentDownloadFailure extends AttachmentDownloadState {
  final Failure failure;

  AttachmentDownloadFailure({
    @required this.failure,
  });
}
