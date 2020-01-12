import 'package:meta/meta.dart';

@immutable
abstract class ProfessorsEvent {}

class GetProfessorsForSubject extends ProfessorsEvent {
  final int subjectId;

  GetProfessorsForSubject({
    @required this.subjectId,
  });
}
