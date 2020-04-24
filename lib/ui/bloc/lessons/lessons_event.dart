import 'package:flutter/material.dart';

abstract class LessonsEvent {
  const LessonsEvent();
}

class UpdateTodayLessons extends LessonsEvent {}

/// Updates [all] the lessons from the start of the year
class UpdateAllLessons extends LessonsEvent {}

/// Gets the [last] lessons
class GetLastLessons extends LessonsEvent {}

class GetLessonsForSubject extends LessonsEvent {
  final int subjectId;

  const GetLessonsForSubject({@required this.subjectId});
}

/// Gets the lessons for a [date]
class GetLessonsByDate extends LessonsEvent {
  final DateTime dateTime;
  const GetLessonsByDate({@required this.dateTime});
}

/// Gets [all] the lessons
class GetLessons extends LessonsEvent {}
