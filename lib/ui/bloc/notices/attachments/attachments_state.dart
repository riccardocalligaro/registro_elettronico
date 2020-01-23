import 'package:equatable/equatable.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';

abstract class AttachmentsState extends Equatable {
  const AttachmentsState();

  @override
  List<Object> get props => [];
}

class NoticesAttachmentsInitial extends AttachmentsState {}

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
