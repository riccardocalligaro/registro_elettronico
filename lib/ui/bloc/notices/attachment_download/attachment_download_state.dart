import 'package:equatable/equatable.dart';

abstract class AttachmentDownloadState extends Equatable {
  const AttachmentDownloadState();

  @override
  List<Object> get props => [];
}

class AttachmentDownloadInitial extends AttachmentDownloadState {}

class AttachmentDownloadLoading extends AttachmentDownloadState {}

class AttachmentDownloadLoaded extends AttachmentDownloadState {
  final String path;
  AttachmentDownloadLoaded(this.path);
}

class AttachmentDownloadError extends AttachmentDownloadState {
  final String error;
  AttachmentDownloadError(this.error);
}
