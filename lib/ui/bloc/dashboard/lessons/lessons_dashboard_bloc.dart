import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:registro_elettronico/domain/repository/lessons_repository.dart';
import './bloc.dart';

class LessonsDashboardBloc
    extends Bloc<LessonsDashboardEvent, LessonsDashboardState> {
  LessonsRepository lessonsRepository;

  LessonsDashboardBloc(this.lessonsRepository);

  @override
  LessonsDashboardState get initialState => LessonsDashboardInitial();

  @override
  Stream<LessonsDashboardState> mapEventToState(
    LessonsDashboardEvent event,
  ) async* {
    if (event is GetLastLessons) {
      yield* _mapGetLastLessonsEventToState();
    }
  }

  Stream<LessonsDashboardState> _mapGetLastLessonsEventToState() async* {
    yield LessonsDashboardLoadInProgress();

    try {
      final lessons = await lessonsRepository.getLastLessons();
      yield LessonsDashboardLoadSuccess(lessons: lessons);
    } catch (e) {
      yield LessonsDashboardLoadError();
    }
  }
}
