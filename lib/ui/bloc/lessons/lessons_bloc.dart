import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
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

      yield LessonsLoadSuccess(lessons: lessons);
    } catch (e) {
      yield LessonsLoadError(error: e.toString());
    }
  }

  Stream<LessonsState> _mapGetLessonsByDateLessonsToState(
      DateTime dateTime) async* {
    yield LessonsLoadInProgress();
    try {
      final lessons = await lessonsRepository.getLessonsByDate(dateTime);

      yield LessonsLoadSuccess(lessons: lessons);
    } catch (e) {
      yield LessonsLoadError(error: e.toString());
    }
  }

  Stream<LessonsState> _mapGetLessonsToState() async* {
    yield LessonsLoadInProgress();
    try {
      final lessons = await lessonsRepository.getLessons();

      yield LessonsLoadSuccess(lessons: lessons);
    } catch (e) {
      yield LessonsLoadError(error: e.toString());
    }
  }

  Stream<LessonsState> _mapUpdateAllLessonsToState() async* {
    yield LessonsUpdateLoadInProgress();
    try {
      await lessonsRepository.deleteAllLessons();
      await lessonsRepository.updateAllLessons();
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt(PrefsConstants.LAST_UPDATE_LESSONS,
          DateTime.now().millisecondsSinceEpoch);
      yield LessonsUpdateLoadSuccess();
    } on DioError catch (dioError) {
      yield LessonsLoadServerError(serverError: dioError);
    } catch (e) {
      LessonsLoadError(error: e.toString());
    }
  }

  Stream<LessonsState> _mapTodayLessonsToState() async* {
    yield LessonsUpdateLoadInProgress();
    try {
      await lessonsRepository.upadateTodayLessons();
      yield LessonsUpdateLoadSuccess();
    } on DioError catch (dioError) {
      yield LessonsLoadServerError(serverError: dioError);
    } catch (e) {
      LessonsLoadError(error: e.toString());
    }
  }

  Stream<LessonsState> _mapGetLessonsForSubjectToState(int subjectId) async* {
    yield LessonsLoadInProgress();
    try {
      final lessons = await lessonsRepository.getLessonsForSubject(subjectId);
      yield LessonsLoadSuccess(lessons: lessons);
    } catch (e) {
      yield LessonsLoadError(error: e.toString());
    }
  }
}
