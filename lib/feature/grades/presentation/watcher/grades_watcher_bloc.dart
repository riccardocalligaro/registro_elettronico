import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures_v2.dart';
import 'package:registro_elettronico/core/infrastructure/generic/resource.dart';
import 'package:registro_elettronico/feature/grades/domain/model/grade_domain_model.dart';
import 'package:registro_elettronico/feature/grades/domain/model/grades_section.dart';
import 'package:registro_elettronico/feature/grades/domain/repository/grades_repository.dart';

part 'grades_watcher_event.dart';
part 'grades_watcher_state.dart';

class GradesWatcherBloc extends Bloc<GradesWatcherEvent, GradesWatcherState> {
  final GradesRepository gradesRepository;

  StreamSubscription _gradesStreamSubscription;

  GradesWatcherBloc({
    @required this.gradesRepository,
  }) : super(GradesWatcherInitial()) {
    _gradesStreamSubscription =
        gradesRepository.watchAllGradesSections().listen((resource) {
      add(GradesReceived(resource: resource));
    });
  }

  @override
  Stream<GradesWatcherState> mapEventToState(
    GradesWatcherEvent event,
  ) async* {
    if (event is GradesReceived) {
      if (event.resource.status == Status.failed) {
        yield GradesWatcherFailure(failure: event.resource.failure);
      } else if (event.resource.status == Status.success) {
        yield GradesWatcherLoadSuccess(gradesSections: event.resource.data);
      } else if (event.resource.status == Status.loading) {
        yield GradesWatcherLoading();
      }
    } else if (event is RestartWatcher) {
      await _gradesStreamSubscription.cancel();
      _gradesStreamSubscription =
          gradesRepository.watchAllGradesSections().listen((resource) {
        add(GradesReceived(resource: resource));
      });
    }
  }

  @override
  Future<void> close() {
    _gradesStreamSubscription.cancel();
    return super.close();
  }
}
