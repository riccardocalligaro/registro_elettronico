part of 'lessons_bloc.dart';

@immutable
abstract class LessonsState {}

class LessonsInitial extends LessonsState {}


class LessonsLoadInProgress extends LessonsState {}

class LessonsLoadErrorNotConnected extends LessonsState {}

class LessonsLoadSuccess extends LessonsState {
  final List<Lesson> lessons;

   LessonsLoadSuccess({
    @required this.lessons,
  });
}

// Updates

class LessonsUpdateLoadInProgress extends LessonsState {}

class LessonsUpdateLoadSuccess extends LessonsState {}

class LessonsLoadServerError extends LessonsState {
  final DioError serverError;

  LessonsLoadServerError({@required this.serverError});
}

class LessonsLoadError extends LessonsState {
  final String error;

  LessonsLoadError({@required this.error});
}

