import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:registro_elettronico/domain/repository/agenda_repository.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './bloc.dart';

class AgendaBloc extends Bloc<AgendaEvent, AgendaState> {
  AgendaRepository agendaRepository;

  AgendaBloc(this.agendaRepository);

  @override
  AgendaState get initialState => AgendaInitial();

  @override
  Stream<AgendaState> mapEventToState(
    AgendaEvent event,
  ) async* {
    if (event is UpdateAllAgenda) {
      yield* _mapUpdateAllAgendaToState();
    } else if (event is GetAllAgenda) {
      yield* _mapGetAllAgendaToState();
    } else if (event is GetNextEvents) {
      yield* _mapGetNextEventsToState(event.dateTime, event.numberOfevents);
    } else if (event is UpdateFromDate) {
      yield* _mapUpdateFronDateToState(event.date);
    }
  }

  Stream<AgendaState> _mapUpdateAllAgendaToState() async* {
    yield AgendaUpdateLoadInProgress();
    try {
      await agendaRepository.updateAllAgenda();
      final prefs = await SharedPreferences.getInstance();

      prefs.setInt(PrefsConstants.LAST_UPDATE_HOME,
          DateTime.now().millisecondsSinceEpoch);
      prefs.setInt(
        PrefsConstants.LAST_UPDATE_AGENDA,
        DateTime.now().millisecondsSinceEpoch,
      );

      yield AgendaUpdateLoadSuccess();
    } on DioError catch (e) {
      FLog.error(text: 'Updating all agenda server error ${e.toString()}');
      yield AgendaLoadError(error: e.response.statusMessage.toString());
    } catch (e) {
      FLog.error(text: 'Updating all agenda  error ${e.toString()}');
      yield AgendaLoadError(error: e.toString());
    }
  }

  Stream<AgendaState> _mapGetAllAgendaToState() async* {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    yield AgendaLoadInProgress();
    try {
      final events = await agendaRepository.getAllEvents();
      prefs.setInt(PrefsConstants.LAST_UPDATE_HOME,
          DateTime.now().millisecondsSinceEpoch);
      yield AgendaLoadSuccess(events: events);
    } catch (e) {
      FLog.error(text: 'Getting agenda error ${e.toString()}');
      yield AgendaLoadError(error: e.toString());
    }
  }

  Stream<AgendaState> _mapGetNextEventsToState(
      DateTime dateTime, int numberOfevents) async* {
    yield AgendaLoadInProgress();
    try {
      final events = await agendaRepository.getLastEvents(
        dateTime,
        numberOfevents,
      );
      yield AgendaLoadSuccess(events: events);
    } catch (e) {
      FLog.error(text: 'Getting agenda error ${e.toString()}');
      yield AgendaLoadError(error: e.toString());
    }
  }

  Stream<AgendaState> _mapUpdateFronDateToState(DateTime date) async* {
    yield AgendaUpdateLoadInProgress();
    try {
      await agendaRepository.updateAgendaStartingFromDate(date);
      yield AgendaUpdateLoadSuccess();
    } on DioError catch (e) {
      yield AgendaLoadError(error: e.response.statusMessage.toString());
    } catch (e) {
      yield AgendaLoadError(error: e.toString());
    }
  }
}
