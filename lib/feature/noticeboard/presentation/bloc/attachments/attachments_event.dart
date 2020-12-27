part of 'attachments_bloc.dart';

@immutable
abstract class AttachmentsEvent {}

class GetAttachments extends AttachmentsEvent {
  final Notice notice;

  GetAttachments({
    @required this.notice,
  });
}
