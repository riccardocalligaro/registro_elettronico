import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:registro_elettronico/data/db/dao/absence_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/domain/repository/absences_repository.dart';
import './bloc.dart';

class AbsencesBloc extends Bloc<AbsencesEvent, AbsencesState> {
  AbsencesRepository absencesRepository;
  AbsencesBloc(this.absencesRepository);

  Stream<List<Absence>> watchAgenda() => absencesRepository.watchAllAbsences();

  @override
  AbsencesState get initialState => AbsencesInitial();

  @override
  Stream<AbsencesState> mapEventToState(
    AbsencesEvent event,
  ) async* {
    if (event is FetchAbsences) {
      yield AbsencesLoading();
      try {
        await absencesRepository.updateAbsences();
        yield AbsencesLoaded();
      } on DioError catch (e) {
        yield AbsencesError(e.response.data.toString());
      } catch (e) {
        yield AbsencesError(e.toString());
      }
    }
  }
}
