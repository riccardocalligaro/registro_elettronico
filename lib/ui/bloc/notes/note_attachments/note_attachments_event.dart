import 'package:meta/meta.dart';

@immutable
abstract class NoteAttachmentsEvent {}

class ReadNote extends NoteAttachmentsEvent {
  final String type;
  final int eventId;

  ReadNote({
    @required this.type,
    @required this.eventId,
  });
}
