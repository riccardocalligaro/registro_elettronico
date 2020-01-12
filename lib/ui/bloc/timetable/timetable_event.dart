import 'package:meta/meta.dart';

@immutable
abstract class TimetableEvent {}

class GetTimetable extends TimetableEvent {}

class GetNewTimetable extends TimetableEvent {}
