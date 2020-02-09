import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:registro_elettronico/core/error/failures.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/domain/repository/absences_repository.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './bloc.dart';

class AbsencesBloc extends Bloc<AbsencesEvent, AbsencesState> {
  AbsencesRepository absencesRepository;

  AbsencesBloc(this.absencesRepository);

  Stream<List<Absence>> watchAbsences() =>
      absencesRepository.watchAllAbsences();

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
        SharedPreferences prefs = Injector.appInstance.getDependency();
        prefs.setInt(
          PrefsConstants.LAST_UPDATE_ABSENCES,
          DateTime.now().millisecondsSinceEpoch,
        );
        yield AbsencesUpdateLoaded();
      } on DioError catch (e, s) {
        Crashlytics.instance.recordError(e, s);
        FLog.error(text: 'Updating asbences error ${e.toString()}');
        yield AbsencesUpdateError(e.response.data.toString());
      } on NotConntectedException catch (_) {
        yield AbsencesLoadErrorNotConnected();
      } catch (e, s) {
        Crashlytics.instance.recordError(e, s);
        FLog.error(text: 'Updating absences error ${e.toString()}');
        yield AbsencesUpdateError(e.toString());
      }
    }

    if (event is GetAbsences) {
      yield AbsencesLoading();
      try {
        final absences = await absencesRepository.getAllAbsences();
        FLog.info(text: 'BloC -> Got ${absences.length} absences');
        yield AbsencesLoaded(absences: absences);
      } catch (e, s) {
        Crashlytics.instance.recordError(e, s);
        FLog.error(text: 'Getting absences error ${e.toString()}');
        yield AbsencesError(e.toString());
      }
    }
  }
}
