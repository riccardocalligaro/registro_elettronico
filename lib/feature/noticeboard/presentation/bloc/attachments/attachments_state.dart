part of 'attachments_bloc.dart';

@immutable
abstract class AttachmentsState {}

class AttachmentsInitial extends AttachmentsState {}

/// Attachments

class NoticesAttachmentsLoading extends AttachmentsState {}

class NoticesAttachmentsLoadNotConnected extends AttachmentsState {}


class NoticesAttachmentsLoaded extends AttachmentsState {
  final List<Attachment> attachments;
  NoticesAttachmentsLoaded(this.attachments);
}

class NoticesAttachmentsError extends AttachmentsState {
  final String error;
  NoticesAttachmentsError(this.error);
}
