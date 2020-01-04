import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:registro_elettronico/data/db/moor_database.dart' as db;
import 'package:registro_elettronico/domain/repository/agenda_repository.dart';

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
      yield AgendaUpdateLoadSuccess();
    } on DioError catch (e) {
      yield AgendaLoadError(error: e.response.statusMessage.toString());
    } catch (e) {
      yield AgendaLoadError(error: e.toString());
    }
  }

  Stream<AgendaState> _mapGetAllAgendaToState() async* {
    yield AgendaLoadInProgress();
    try {
      final events = await agendaRepository.getAllEvents();
      yield AgendaLoadSuccess(events: events);
    } catch (e) {
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
