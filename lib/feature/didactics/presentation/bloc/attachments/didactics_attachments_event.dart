part of 'didactics_attachments_bloc.dart';

@immutable
abstract class DidacticsAttachmentsEvent {}

class GetAttachment extends DidacticsAttachmentsEvent {
  final DidacticsContent content;

  GetAttachment({@required this.content});
}

class DeleteAttachment extends DidacticsAttachmentsEvent {
  final DidacticsContent content;

  DeleteAttachment({@required this.content});
}
