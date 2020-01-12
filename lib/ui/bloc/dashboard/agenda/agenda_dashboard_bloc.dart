import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:registro_elettronico/domain/repository/agenda_repository.dart';
import './bloc.dart';

class AgendaDashboardBloc
    extends Bloc<AgendaDashboardEvent, AgendaDashboardState> {
  AgendaRepository agendaRepository;

  AgendaDashboardBloc(this.agendaRepository);

  @override
  AgendaDashboardState get initialState => AgendaDashboardInitial();

  @override
  Stream<AgendaDashboardState> mapEventToState(
    AgendaDashboardEvent event,
  ) async* {
    if (event is GetEvents) {
      yield* _mapGetEventsEventToState();
    }
  }

  Stream<AgendaDashboardState> _mapGetEventsEventToState() async* {
    yield AgendaDashboardLoadInProgress();
    try {
      final events = await agendaRepository.getLastEvents(DateTime.now(), 3);
      yield AgendaDashboardLoadSuccess(events: events);
    } catch (e) {
      yield AgendaDashboardLoadError();
    }
  }
}
