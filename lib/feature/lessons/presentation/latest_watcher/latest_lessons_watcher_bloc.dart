import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures_v2.dart';
import 'package:registro_elettronico/core/infrastructure/generic/resource.dart';
import 'package:registro_elettronico/feature/lessons/domain/model/last_lessons_domain_model.dart';
import 'package:registro_elettronico/feature/lessons/domain/repository/lessons_repository.dart';

part 'latest_lessons_watcher_event.dart';
part 'latest_lessons_watcher_state.dart';

class LatestLessonsWatcherBloc
    extends Bloc<LatestLessonsWatcherEvent, LatestLessonsWatcherState> {
  final LessonsRepository lessonsRepository;

  StreamSubscription _latestLessonsSubscription;

  LatestLessonsWatcherBloc({
    @required this.lessonsRepository,
  }) : super(LatestLessonsWatcherInitial()) {
    _latestLessonsSubscription =
        lessonsRepository.watchLatestLessonsWithDuration().listen((resource) {
      add(LatestLessonsReceived(resource: resource));
    });
  }

  @override
  Stream<LatestLessonsWatcherState> mapEventToState(
    LatestLessonsWatcherEvent event,
  ) async* {
    if (event is LatestLessonsReceived) {
      if (event.resource.status == Status.failed) {
        yield LatestLessonsWatcherFailure(failure: event.resource.failure);
      } else if (event.resource.status == Status.success) {
        yield LatestLessonsWatcherLoadSuccess(lessons: event.resource.data);
      } else if (event.resource.status == Status.loading) {
        yield LatestLessonsWatcherLoading();
      }
    }
  }

  @override
  Future<void> close() {
    _latestLessonsSubscription.cancel();
    return super.close();
  }
}
