part of 'attachment_download_bloc.dart';

@immutable
abstract class AttachmentDownloadState {}

class AttachmentDownloadInitial extends AttachmentDownloadState {}

class AttachmentDownloadInProgress extends AttachmentDownloadState {
  final double? percentage;

  AttachmentDownloadInProgress({
    required this.percentage,
  });
}

class AttachmentDownloadSuccess extends AttachmentDownloadState {
  final GenericAttachment? downloadedAttachment;

  AttachmentDownloadSuccess({
    required this.downloadedAttachment,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AttachmentDownloadSuccess &&
        other.downloadedAttachment == downloadedAttachment;
  }

  @override
  int get hashCode => downloadedAttachment.hashCode;
}

class AttachmentDownloadFailure extends AttachmentDownloadState {
  final Failure? failure;

  AttachmentDownloadFailure({
    required this.failure,
  });
}
