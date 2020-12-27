part of 'attachment_download_bloc.dart';

@immutable
abstract class AttachmentDownloadEvent {}

class DownloadAttachment extends AttachmentDownloadEvent {
  final Notice notice;
  final Attachment attachment;
  DownloadAttachment({
    @required this.notice,
    @required this.attachment,
  });
}

