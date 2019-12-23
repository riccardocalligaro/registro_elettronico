import 'package:equatable/equatable.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';

abstract class NoticesState extends Equatable {
  const NoticesState();

  @override
  List<Object> get props => [];
}

class NoticesInitial extends NoticesState {}

class NoticesUpdateLoading extends NoticesState {}

class NoticesUpdateLoaded extends NoticesState {}

class NoticesUpdateError extends NoticesState {
  final String error;

  NoticesUpdateError(this.error);
}

/// Notices
class NoticesLoading extends NoticesState {}

class NoticesLoaded extends NoticesState {
  final List<Notice> notices;

  NoticesLoaded(this.notices);
}

class NoticesError extends NoticesState {
  final String error;

  NoticesError(this.error);
}

/// Attachments

class NoticesAttachmentsLoading extends NoticesState {}

class NoticesAttachmentsLoaded extends NoticesState {
  final List<Attachment> attachments;
  NoticesAttachmentsLoaded(this.attachments);
}

class NoticesAttachmentsError extends NoticesState {
  final String error;
  NoticesAttachmentsError(this.error);
}

/// Download of attachment

class NoticesAttachmentDownloadLoading extends NoticesState {}

class NoticesAttachmentDownloadLoaded extends NoticesState {
  final String path;
  NoticesAttachmentDownloadLoaded(this.path);
}

class NoticesAttachmentDownloadError extends NoticesState {
  final String error;
  NoticesAttachmentDownloadError(this.error);
}
