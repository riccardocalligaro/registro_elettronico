import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:registro_elettronico/component/app_injection.dart';
import 'package:registro_elettronico/core/error/failures.dart';
import 'package:registro_elettronico/feature/agenda/domain/repository/agenda_repository.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:registro_elettronico/data/db/moor_database.dart' as db;

part 'agenda_event.dart';
part 'agenda_state.dart';

class AgendaBloc extends Bloc<AgendaEvent, AgendaState> {
  final AgendaRepository agendaRepository;

  AgendaBloc({
    @required this.agendaRepository,
  }) : super(AgendaInitial());

  @override
  Stream<AgendaState> mapEventToState(
    AgendaEvent event,
  ) async* {
    if (event is UpdateAllAgenda) {
      yield* _mapUpdateAllAgendaToState();
    } else if (event is GetAllAgenda) {
      yield* _mapGetAllAgendaToState();
    } else if (event is GetNextEvents) {
      yield* _mapGetNextEventsToState(event.dateTime);
    } else if (event is UpdateFromDate) {
      yield* _mapUpdateFronDateToState(event.date);
    }
  }

  Stream<AgendaState> _mapUpdateAllAgendaToState() async* {
    // yield AgendaUpdateLoadInProgress();
    try {
      FLog.info(text: 'updating here');
      await agendaRepository.updateAllAgenda();
      SharedPreferences prefs = sl();

      prefs.setInt(PrefsConstants.LAST_UPDATE_HOME,
          DateTime.now().millisecondsSinceEpoch);
      prefs.setInt(
        PrefsConstants.LAST_UPDATE_AGENDA,
        DateTime.now().millisecondsSinceEpoch,
      );

      yield AgendaUpdateLoadSuccess();
    } on NotConntectedException catch (_) {
      yield AgendaLoadErrorNotConnected();
    } on DioError catch (e) {
      yield AgendaLoadError(error: e.response.statusMessage.toString());
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s);
      FLog.error(text: 'Updating all agenda  error ${e.toString()}');
      yield AgendaLoadError(error: e.toString());
    }
  }

  Stream<AgendaState> _mapGetAllAgendaToState() async* {
    SharedPreferences prefs = sl();
    try {
      final events = await agendaRepository.getAllEvents();
      prefs.setInt(PrefsConstants.LAST_UPDATE_HOME,
          DateTime.now().millisecondsSinceEpoch);
      FLog.info(text: 'BloC -> Got ${events.length} events');

      final Map<DateTime, List<db.AgendaEvent>> eventsMap = Map.fromIterable(
        events,
        key: (e) => e.begin,
        value: (e) => events
            .where((event) => DateUtils.areSameDay(event.begin, e.begin))
            .toList(),
      );
      yield AgendaLoadSuccess(events: events, eventsMap: eventsMap);
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s);
      FLog.error(text: 'Getting agenda error ${e.toString()}');
      yield AgendaLoadError(error: e.toString());
    }
  }

  Stream<AgendaState> _mapGetNextEventsToState(DateTime dateTime) async* {
    yield AgendaLoadInProgress();
    try {
      final events = await agendaRepository.getLastEvents(
        dateTime,
      );

      final Map<DateTime, List<db.AgendaEvent>> eventsMap = Map.fromIterable(
        events,
        key: (e) => e.begin,
        value: (e) => events
            .where((event) => DateUtils.areSameDay(event.begin, e.begin))
            .toList(),
      );
      yield AgendaLoadSuccess(events: events, eventsMap: eventsMap);
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s);
      FLog.error(text: 'Getting agenda error ${e.toString()}');
      yield AgendaLoadError(error: e.toString());
    }
  }

  Stream<AgendaState> _mapUpdateFronDateToState(DateTime date) async* {
    try {
      await agendaRepository.updateAgendaStartingFromDate(date);
      yield AgendaUpdateLoadSuccess();
    } on NotConntectedException catch (_) {
      yield AgendaLoadErrorNotConnected();
    } on DioError catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s);
      yield AgendaLoadError(error: e.response.statusMessage.toString());
    } catch (e) {
      yield AgendaLoadError(error: e.toString());
    }
  }
}
