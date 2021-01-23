import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures_v2.dart';
import 'package:registro_elettronico/core/infrastructure/generic/resource.dart';
import 'package:registro_elettronico/feature/lessons/domain/model/lesson_domain_model.dart';
import 'package:registro_elettronico/feature/lessons/domain/repository/lessons_repository.dart';

part 'lessons_watcher_event.dart';
part 'lessons_watcher_state.dart';

class LessonsWatcherBloc
    extends Bloc<LessonsWatcherEvent, LessonsWatcherState> {
  final LessonsRepository lessonsRepository;

  StreamSubscription _lessonsStreamSubscription;

  LessonsWatcherBloc({
    @required this.lessonsRepository,
  }) : super(LessonsWatcherInitial());

  @override
  Stream<LessonsWatcherState> mapEventToState(
    LessonsWatcherEvent event,
  ) async* {
    if (event is LessonsReceived) {
      if (event.resource.status == Status.failed) {
        yield LessonsWatcherFailure(failure: event.resource.failure);
      } else if (event.resource.status == Status.success) {
        yield LessonsWatcherLoadSuccess(lessons: event.resource.data);
      } else if (event.resource.status == Status.loading) {
        yield LessonsWatcherLoading();
      }
    } else if (event is LessonsWatchAllStarted) {
      _startListening(event.subjectId);
    } else if (event is LessonsRestartWatcher) {
      await _lessonsStreamSubscription.cancel();
      _startListening(event.subjectId);
    }
  }

  void _startListening(int subjectId) {
    _lessonsStreamSubscription = lessonsRepository
        .watchLessonsForSubjectId(subjectId: subjectId)
        .listen((resource) {
      add(LessonsReceived(resource: resource));
    });
  }

  @override
  Future<void> close() {
    _lessonsStreamSubscription.cancel();
    return super.close();
  }
}
