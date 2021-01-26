import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures_v2.dart';
import 'package:registro_elettronico/core/infrastructure/generic/resource.dart';
import 'package:registro_elettronico/feature/agenda/domain/model/agenda_data_domain_model.dart';
import 'package:registro_elettronico/feature/agenda/domain/repository/agenda_repository.dart';

part 'agenda_watcher_event.dart';
part 'agenda_watcher_state.dart';

class AgendaWatcherBloc extends Bloc<AgendaWatcherEvent, AgendaWatcherState> {
  final AgendaRepository agendaRepository;

  StreamSubscription _agendaStreamSubscription;

  AgendaWatcherBloc({
    @required this.agendaRepository,
  }) : super(AgendaWatcherInitial()) {
    _agendaStreamSubscription =
        agendaRepository.watchAgendaData().listen((resource) {
      add(AgendaDataReceived(resource: resource));
    });
  }

  @override
  Stream<AgendaWatcherState> mapEventToState(
    AgendaWatcherEvent event,
  ) async* {
    if (event is AgendaDataReceived) {
      if (event.resource.status == Status.failed) {
        yield AgendaWatcherFailure(failure: event.resource.failure);
      } else if (event.resource.status == Status.success) {
        yield AgendaWatcherLoadSuccess(
          agendaDataDomainModel: event.resource.data,
        );
      } else if (event.resource.status == Status.loading) {
        yield AgendaWatcherLoading();
      }
    }
  }

  @override
  Future<void> close() {
    _agendaStreamSubscription.cancel();
    return super.close();
  }
}
