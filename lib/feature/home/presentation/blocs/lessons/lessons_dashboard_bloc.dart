import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:registro_elettronico/core/infrastructure/log/logger.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:meta/meta.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/lessons/domain/repository/lessons_repository.dart';

part 'lessons_dashboard_event.dart';
part 'lessons_dashboard_state.dart';

class LessonsDashboardBloc
    extends Bloc<LessonsDashboardEvent, LessonsDashboardState> {
  final LessonsRepository lessonsRepository;

  LessonsDashboardBloc({
    @required this.lessonsRepository,
  }) : super(LessonsDashboardInitial());

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
      Logger.info('BloC -> Got ${lessons.length} lessons');
      yield LessonsDashboardLoadSuccess(lessons: lessons);
    } catch (e, s) {
      await FirebaseCrashlytics.instance.recordError(e, s);
      yield LessonsDashboardLoadError();
    }
  }
}
