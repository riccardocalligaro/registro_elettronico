import 'package:meta/meta.dart';

@immutable
abstract class TimetableEvent {}

class GetTimetable extends TimetableEvent {}

class GetNewTimetable extends TimetableEvent {
  final DateTime begin;
  final DateTime end;

  GetNewTimetable({
    @required this.begin,
    @required this.end,
  });
}
