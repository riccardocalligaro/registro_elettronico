import 'package:equatable/equatable.dart';

abstract class LessonsEvent extends Equatable {
  const LessonsEvent();

  @override
  List<Object> get props => [];
}

class FetchTodayLessons extends LessonsEvent {}

class FetchAllLessons extends LessonsEvent {}