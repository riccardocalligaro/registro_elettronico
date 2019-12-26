import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/domain/repository/absences_repository.dart';

import './bloc.dart';

class AbsencesBloc extends Bloc<AbsencesEvent, AbsencesState> {
  AbsencesRepository absencesRepository;
  
  AbsencesBloc(this.absencesRepository);

  Stream<List<Absence>> watchAbsences() => absencesRepository.watchAllAbsences();

  @override
  AbsencesState get initialState => AbsencesInitial();

  @override
  Stream<AbsencesState> mapEventToState(
    AbsencesEvent event,
  ) async* {
    if (event is FetchAbsences) {
      yield AbsencesUpdateLoading();
      try {
        await absencesRepository.updateAbsences();
        yield AbsencesUpdateLoaded();
      } on DioError catch (e) {
        yield AbsencesUpdateError(e.response.data.toString());
      } catch (e) {
        yield AbsencesUpdateError(e.toString());
      }
    }

    if (event is GetAbsences) {
      yield AbsencesLoading();
      try {
        final absences = await absencesRepository.getAllAbsences();
        yield AbsencesLoaded(absences: absences);
      } catch (e) {
        yield AbsencesError(e.toString());
      }
    }
  }
}
