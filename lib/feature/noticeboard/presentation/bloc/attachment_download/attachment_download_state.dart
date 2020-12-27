part of 'attachment_download_bloc.dart';

@immutable
abstract class AttachmentDownloadState {}

class AttachmentDownloadInitial extends AttachmentDownloadState {}

class AttachmentDownloadLoading extends AttachmentDownloadState {}

class AttachmentDownloadLoadNotConnected extends AttachmentDownloadState {}

class AttachmentDownloadLoaded extends AttachmentDownloadState {
  final String path;
  AttachmentDownloadLoaded(this.path);
}

class AttachmentDownloadError extends AttachmentDownloadState {
  final String error;
  AttachmentDownloadError(this.error);
}
