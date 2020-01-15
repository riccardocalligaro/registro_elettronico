import 'package:meta/meta.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';

@immutable
abstract class DocumentAttachmentEvent {}

class GetDocumentAttachment extends DocumentAttachmentEvent {
  final Document document;

  GetDocumentAttachment({@required this.document});
}
