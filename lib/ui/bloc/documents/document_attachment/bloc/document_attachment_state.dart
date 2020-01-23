import 'package:meta/meta.dart';

@immutable
abstract class DocumentAttachmentState {}

class DocumentAttachmentInitial extends DocumentAttachmentState {}

class DocumentLoadInProgress extends DocumentAttachmentState {}

class DocumentLoadedLocally extends DocumentAttachmentState {
  final String path;

  DocumentLoadedLocally({@required this.path});
}

class DocumentNotAvailable extends DocumentAttachmentState {}

class DocumentLoadNotConnected extends DocumentAttachmentState {}

class DocumentLoadSuccess extends DocumentAttachmentState {
  final String path;

  DocumentLoadSuccess({@required this.path});
}

class DocumentAttachmentError extends DocumentAttachmentState {}

// Delete

class DocumentAttachmentDeleteSuccess extends DocumentAttachmentState {}

class DocumentAttachmentDeleteError extends DocumentAttachmentState {}
