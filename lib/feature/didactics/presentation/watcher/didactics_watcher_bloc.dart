import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures_v2.dart';
import 'package:registro_elettronico/core/infrastructure/generic/resource.dart';
import 'package:registro_elettronico/feature/didactics/domain/model/teacher_domain_model.dart';
import 'package:registro_elettronico/feature/didactics/domain/repository/didactics_repository.dart';

part 'didactics_watcher_event.dart';
part 'didactics_watcher_state.dart';

class DidacticsWatcherBloc
    extends Bloc<DidacticsWatcherEvent, DidacticsWatcherState> {
  final DidacticsRepository didacticsRepository;

  StreamSubscription _didacticsStreamSubscription;

  DidacticsWatcherBloc({
    @required this.didacticsRepository,
  }) : super(DidacticsWatcherInitial());

  @override
  Stream<DidacticsWatcherState> mapEventToState(
    DidacticsWatcherEvent event,
  ) async* {
    if (event is DidacticsDataReceived) {
      if (event.resource.status == Status.failed) {
        yield DidacticsWatcherFailure(failure: event.resource.failure);
      } else if (event.resource.status == Status.success) {
        yield DidacticsWatcherLoadSuccess(
          teachers: event.resource.data,
        );
      } else if (event.resource.status == Status.loading) {
        yield DidacticsWatcherLoading();
      }
    } else if (event is DidacticsWatchAllStarted) {
      if (_didacticsStreamSubscription != null) {
        await _didacticsStreamSubscription.cancel();
      }
      _didacticsStreamSubscription =
          didacticsRepository.watchTeachersMaterials().listen((event) {
        add(DidacticsDataReceived(resource: event));
      });
    }
  }

  @override
  Future<void> close() {
    _didacticsStreamSubscription.cancel();
    return super.close();
  }
}
