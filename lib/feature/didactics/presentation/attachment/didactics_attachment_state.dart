part of 'didactics_attachment_bloc.dart';

@immutable
abstract class DidacticsAttachmentState {}

class DidacticsAttachmentInitial extends DidacticsAttachmentState {}

class DidacticsAttachmentDownloadInProgress extends DidacticsAttachmentState {
  final double? percentage;

  DidacticsAttachmentDownloadInProgress({
    required this.percentage,
  });
}

class DidacticsAttachmentFileDownloadSuccess extends DidacticsAttachmentState {
  final DidacticsFile? didacticsFile;

  DidacticsAttachmentFileDownloadSuccess({required this.didacticsFile});
}

class DidacticsAttachmentURLDownloadSuccess extends DidacticsAttachmentState {
  final URLContentRemoteModel urlContentRemoteModel;

  DidacticsAttachmentURLDownloadSuccess({required this.urlContentRemoteModel});
}

class DidacticsAttachmentTextDownloadSuccess extends DidacticsAttachmentState {
  final TextContentRemoteModel textContentRemoteModel;

  DidacticsAttachmentTextDownloadSuccess({
    required this.textContentRemoteModel,
  });
}

class DidacticsAttachmentDownloadFailure extends DidacticsAttachmentState {
  final Failure? failure;

  DidacticsAttachmentDownloadFailure({
    required this.failure,
  });
}
