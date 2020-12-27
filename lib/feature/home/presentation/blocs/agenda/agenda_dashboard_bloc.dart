import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:meta/meta.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/agenda/domain/repository/agenda_repository.dart';

part 'agenda_dashboard_event.dart';

part 'agenda_dashboard_state.dart';

class AgendaDashboardBloc
    extends Bloc<AgendaDashboardEvent, AgendaDashboardState> {
  final AgendaRepository agendaRepository;

  AgendaDashboardBloc({
    @required this.agendaRepository,
  }) : super(AgendaDashboardInitial());

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
      final events = await agendaRepository.getLastEvents(DateTime.now());
      FLog.info(text: 'BloC -> Got ${events.length} events dashboard');

      yield AgendaDashboardLoadSuccess(events: events);
    } on Exception catch (e, s) {
      FLog.error(
        text: 'Error getting dashboard',
        exception: e,
        stacktrace: s,
      );
      FirebaseCrashlytics.instance.recordError(e, s);
      yield AgendaDashboardLoadError();
    }
  }
}
