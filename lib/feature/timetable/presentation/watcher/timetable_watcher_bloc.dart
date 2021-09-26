import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures_v2.dart';
import 'package:registro_elettronico/core/infrastructure/generic/resource.dart';
import 'package:registro_elettronico/feature/timetable/domain/model/timetable_data_domain_model.dart';
import 'package:registro_elettronico/feature/timetable/domain/repository/timetable_repository.dart';

part 'timetable_watcher_event.dart';
part 'timetable_watcher_state.dart';

class TimetableWatcherBloc
    extends Bloc<TimetableWatcherEvent, TimetableWatcherState> {
  final TimetableRepository? timetableRepository;

  StreamSubscription? _timetableStreamSubscription;

  TimetableWatcherBloc({
    required this.timetableRepository,
  }) : super(TimetableWatcherInitial());

  @override
  Stream<TimetableWatcherState> mapEventToState(
    TimetableWatcherEvent event,
  ) async* {
    if (event is TimetableReceived) {
      if (event.resource.status == Status.failed) {
        yield TimetableWatcherFailure(failure: event.resource.failure);
      } else if (event.resource.status == Status.success) {
        yield TimetableWatcherLoadSuccess(timetableData: event.resource.data);
      } else if (event.resource.status == Status.loading) {
        yield TimetableWatcherLoading();
      }
    } else if (event is TimetableRestartWatcher) {
      await _timetableStreamSubscription!.cancel();
      _startStreamListener();
    } else if (event is TimetableStartWatcherIfNeeded) {
      if (_timetableStreamSubscription == null) {
        _startStreamListener();
      }
    }
  }

  void _startStreamListener() {
    _timetableStreamSubscription =
        timetableRepository!.watchTimetableData().listen((resource) {
      add(TimetableReceived(resource: resource));
    });
  }

  @override
  Future<void> close() {
    _timetableStreamSubscription!.cancel();
    return super.close();
  }
}
