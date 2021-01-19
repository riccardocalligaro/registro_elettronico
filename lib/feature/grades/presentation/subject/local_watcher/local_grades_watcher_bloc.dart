import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures_v2.dart';
import 'package:registro_elettronico/core/infrastructure/generic/resource.dart';
import 'package:registro_elettronico/feature/grades/domain/model/grade_domain_model.dart';
import 'package:registro_elettronico/feature/grades/domain/model/grades_section.dart';
import 'package:registro_elettronico/feature/grades/domain/repository/grades_repository.dart';

part 'local_grades_watcher_event.dart';
part 'local_grades_watcher_state.dart';

class LocalGradesWatcherBloc
    extends Bloc<LocalGradesWatcherEvent, LocalGradesWatcherState> {
  final GradesRepository gradesRepository;

  StreamSubscription _localGradesStreamSubscription;

  LocalGradesWatcherBloc({
    @required this.gradesRepository,
  }) : super(LocalGradesWatcherInitial());

  @override
  Stream<LocalGradesWatcherState> mapEventToState(
    LocalGradesWatcherEvent event,
  ) async* {
    if (event is LocalGradesReceived) {
      if (event.resource.status == Status.failed) {
        yield LocalGradesWatcherFailure(failure: event.resource.failure);
      } else if (event.resource.status == Status.success) {
        yield LocalGradesWatcherLoadSuccess(grades: event.resource.data);
      } else if (event.resource.status == Status.loading) {
        yield LocalGradesWatcherLoading();
      }
    } else if (event is LocalGradesWatchAllStarted) {
      _localGradesStreamSubscription = gradesRepository
          .watchLocalGrades(
              subjectId: event.subjectId, periodPos: event.periodPos)
          .listen((resource) {
        add(LocalGradesReceived(resource: resource));
      });
    }
  }

  @override
  Future<void> close() {
    _localGradesStreamSubscription.cancel();
    return super.close();
  }
}
