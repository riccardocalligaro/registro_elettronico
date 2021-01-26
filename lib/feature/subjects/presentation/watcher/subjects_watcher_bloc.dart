import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures_v2.dart';
import 'package:registro_elettronico/core/infrastructure/generic/resource.dart';
import 'package:registro_elettronico/feature/subjects/domain/model/subject_domain_model.dart';
import 'package:registro_elettronico/feature/subjects/domain/repository/subjects_repository.dart';

part 'subjects_watcher_event.dart';
part 'subjects_watcher_state.dart';

class SubjectsWatcherBloc
    extends Bloc<SubjectsWatcherEvent, SubjectsWatcherState> {
  final SubjectsRepository subjectsRepository;

  StreamSubscription _subjectsStreamSubscription;

  SubjectsWatcherBloc({
    @required this.subjectsRepository,
  }) : super(SubjectsWatcherInitial());

  @override
  Stream<SubjectsWatcherState> mapEventToState(
    SubjectsWatcherEvent event,
  ) async* {
    if (event is SubjectsReceived) {
      if (event.resource.status == Status.failed) {
        yield SubjectsWatcherFailure(failure: event.resource.failure);
      } else if (event.resource.status == Status.success) {
        yield SubjectsWatcherLoadSuccess(subjects: event.resource.data);
      } else if (event.resource.status == Status.loading) {
        yield SubjectsWatcherLoading();
      }
    } else if (event is SubjectsRestartWatcher) {
      await _subjectsStreamSubscription.cancel();
      _startStreamListener();
    } else if (event is SubjectsStartWatcherIfNeeded) {
      if (_subjectsStreamSubscription == null) {
        _startStreamListener();
      }
    }
  }

  void _startStreamListener() {
    _subjectsStreamSubscription =
        subjectsRepository.watchAllSubjects().listen((resource) {
      add(SubjectsReceived(resource: resource));
    });
  }

  @override
  Future<void> close() {
    _subjectsStreamSubscription.cancel();
    return super.close();
  }
}
