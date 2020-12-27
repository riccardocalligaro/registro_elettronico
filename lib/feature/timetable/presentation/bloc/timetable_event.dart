part of 'timetable_bloc.dart';

@immutable
abstract class TimetableEvent {}

class GetTimetable extends TimetableEvent {}

class GetNewTimetable extends TimetableEvent {}
