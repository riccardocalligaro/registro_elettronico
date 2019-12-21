import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:registro_elettronico/data/db/dao/agenda_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart' as db;
import 'package:registro_elettronico/domain/repository/agenda_repository.dart';

import './bloc.dart';

class AgendaBloc extends Bloc<AgendaEvent, AgendaState> {
  AgendaRepository agendaRepository;

  AgendaBloc(this.agendaRepository);

  Stream<List<db.AgendaEvent>> watchAllEvents() =>
      agendaRepository.watchLastEvents(DateTime.now(), 3);

  Stream<List<db.AgendaEvent>> watchAgenda() =>
      agendaRepository.watchAllEvents();

  @override
  AgendaState get initialState => AgendaInitial();

  @override
  Stream<AgendaState> mapEventToState(
    AgendaEvent event,
  ) async* {
    if (event is FetchAgenda) {
      yield AgendaLoading();
      try {
        await agendaRepository.updateAllAgenda();
        yield AgendaLoaded();
      } on DioError catch (e) {
        yield AgendaError(e.response.data.toString());
      } catch (e) {
        yield AgendaError(e.toString());
      }
    }
  }
}
