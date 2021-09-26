part of 'document_attachment_bloc.dart';

@immutable
abstract class DocumentAttachmentEvent {}

class GetDocumentAttachment extends DocumentAttachmentEvent {
  final Document document;

  GetDocumentAttachment({required this.document});
}

class DeleteDocumentAttachment extends DocumentAttachmentEvent {
  final Document document;

  DeleteDocumentAttachment({required this.document});
}
