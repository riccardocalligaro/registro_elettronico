import 'package:meta/meta.dart';

@immutable
abstract class DocumentAttachmentState {}

class DocumentAttachmentInitial extends DocumentAttachmentState {}

class DocumentLoadInProgress extends DocumentAttachmentState {}

class DocumentNotAvailable extends DocumentAttachmentState {}

class DocumentLoadSuccess extends DocumentAttachmentState {
  final String path;

  DocumentLoadSuccess({@required this.path});
}

class DocumentAttachmentError extends DocumentAttachmentState {}
