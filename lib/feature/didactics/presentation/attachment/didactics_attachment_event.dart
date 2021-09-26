part of 'didactics_attachment_bloc.dart';

@immutable
abstract class DidacticsAttachmentEvent {}

class DownloadContentAttachment extends DidacticsAttachmentEvent {
  final ContentDomainModel contentDomainModel;

  DownloadContentAttachment({
    required this.contentDomainModel,
  });
}

class DidacticsAttachmentProgressTickedEvent extends DidacticsAttachmentEvent {
  final double? value;

  DidacticsAttachmentProgressTickedEvent({
    required this.value,
  });
}

class DidacticsAttachmentErrorEvent extends DidacticsAttachmentEvent {
  final Failure? failure;

  DidacticsAttachmentErrorEvent({
    required this.failure,
  });
}

class DidacticsAttachmentFinishedEvent extends DidacticsAttachmentEvent {
  final DidacticsFile? file;

  DidacticsAttachmentFinishedEvent({
    required this.file,
  });
}
