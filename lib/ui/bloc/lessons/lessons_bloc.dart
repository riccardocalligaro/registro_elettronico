import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:f_logs/f_logs.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injector/injector.dart';
import 'package:registro_elettronico/core/error/failures.dart';
import 'package:registro_elettronico/domain/repository/lessons_repository.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './bloc.dart';

/// Bloc for updating all the [lessons]
class LessonsBloc extends Bloc<LessonsEvent, LessonsState> {
  LessonsRepository lessonsRepository;

  LessonsBloc(
    this.lessonsRepository,
  );

  @override
  LessonsState get initialState => LessonsIntial();

  @override
  Stream<LessonsState> mapEventToState(
    LessonsEvent event,
  ) async* {
    if (event is GetLastLessons) {
      yield* _mapGetLastLessonsToState();
    } else if (event is GetLessonsByDate) {
      yield* _mapGetLessonsByDateLessonsToState(event.dateTime);
    } else if (event is GetLessons) {
      yield* _mapGetLessonsToState();
    } else if (event is UpdateAllLessons) {
      yield* _mapUpdateAllLessonsToState();
    } else if (event is UpdateTodayLessons) {
      yield* _mapTodayLessonsToState();
    } else if (event is GetLessonsForSubject) {
      yield* _mapGetLessonsForSubjectToState(event.subjectId);
    }
  }

  Stream<LessonsState> _mapGetLastLessonsToState() async* {
    yield LessonsLoadInProgress();
    try {
      final lessons = await lessonsRepository.getLastLessons();
      FLog.info(text: 'BloC -> Got ${lessons.length} lessons');

      yield LessonsLoadSuccess(lessons: lessons);
    } on Exception catch (e, s) {
      FLog.error(
        text: 'Error getting last lessons by date',
        exception: e,
        stacktrace: s,
      );
      yield LessonsLoadError(error: e.toString());
    }
  }

  Stream<LessonsState> _mapGetLessonsByDateLessonsToState(
      DateTime dateTime) async* {
    yield LessonsLoadInProgress();
    try {
      final lessons = await lessonsRepository.getLessonsByDate(dateTime);
      FLog.info(text: 'BloC -> Got ${lessons.length} lessons');
      yield LessonsLoadSuccess(lessons: lessons);
    } on Exception catch (e, s) {
      FLog.error(
        text: 'Error getting lessons by date',
        exception: e,
        stacktrace: s,
      );
      Crashlytics.instance.recordError(e, s);
      yield LessonsLoadError(error: e.toString());
    }
  }

  Stream<LessonsState> _mapGetLessonsToState() async* {
    yield LessonsLoadInProgress();
    try {
      final lessons = await lessonsRepository.getLessons();
      FLog.info(text: 'BloC -> Got ${lessons.length} events');
      yield LessonsLoadSuccess(lessons: lessons);
    } on Exception catch (e, s) {
      FLog.error(
        text: 'Error getting absences',
        exception: e,
        stacktrace: s,
      );
      Crashlytics.instance.recordError(e, s);
      yield LessonsLoadError(error: e.toString());
    }
  }

  Stream<LessonsState> _mapUpdateAllLessonsToState() async* {
    // yield LessonsUpdateLoadInProgress();
    try {
      await lessonsRepository.updateAllLessons();
      SharedPreferences prefs = Injector.appInstance.getDependency();
      prefs.setInt(PrefsConstants.LAST_UPDATE_LESSONS,
          DateTime.now().millisecondsSinceEpoch);
      yield LessonsUpdateLoadSuccess();
    } on NotConntectedException catch (_) {
      yield LessonsLoadErrorNotConnected();
    } on DioError catch (e, s) {
      FLog.info(text: 'Server - Error updating absences');
      Crashlytics.instance.recordError(e, s);
      yield LessonsLoadServerError(serverError: e);
    } on Exception catch (e, s) {
      FLog.error(
        text: 'Other - Error updating absences',
        exception: e,
        stacktrace: s,
      );
      Crashlytics.instance.recordError(e, s);
      LessonsLoadError(error: e.toString());
    }
  }

  Stream<LessonsState> _mapTodayLessonsToState() async* {
    // yield LessonsUpdateLoadInProgress();
    try {
      await lessonsRepository.upadateTodayLessons();
      yield LessonsUpdateLoadSuccess();
    } on NotConntectedException catch (_) {
      yield LessonsLoadErrorNotConnected();
    } on DioError catch (e, s) {
      FLog.error(
        text: 'Other - Error updating today lessons',
        exception: e,
        stacktrace: s,
      );
      Crashlytics.instance.recordError(e, s);
      yield LessonsLoadServerError(serverError: e);
    } on Exception catch (e, s) {
      FLog.error(
        text: 'Other - Error updating today lessons',
        exception: e,
        stacktrace: s,
      );
      Crashlytics.instance.recordError(e, s);

      LessonsLoadError(error: e.toString());
    }
  }

  Stream<LessonsState> _mapGetLessonsForSubjectToState(int subjectId) async* {
    yield LessonsLoadInProgress();
    try {
      final lessons = await lessonsRepository.getLessonsForSubject(subjectId);
      yield LessonsLoadSuccess(lessons: lessons);
    } on Exception catch (e, s) {
      FLog.error(
        text: 'Other - Error getting lessons for subject lessons',
        exception: e,
        stacktrace: s,
      );
      yield LessonsLoadError(error: e.toString());
    }
  }
}
