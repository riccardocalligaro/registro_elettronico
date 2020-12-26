import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:registro_elettronico/component/app_injection.dart';
import 'package:registro_elettronico/core/error/failures.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/domain/repository/absences_repository.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'absences_event.dart';
part 'absences_state.dart';

class AbsencesBloc extends Bloc<AbsencesEvent, AbsencesState> {
  final AbsencesRepository absencesRepository;

  AbsencesBloc({
    @required this.absencesRepository,
  }) : super(AbsencesInitial());

  @override
  Stream<AbsencesState> mapEventToState(
    AbsencesEvent event,
  ) async* {
    if (event is FetchAbsences) {
      yield AbsencesUpdateLoading();
      try {
        await absencesRepository.updateAbsences();
        SharedPreferences prefs = sl();
        prefs.setInt(
          PrefsConstants.LAST_UPDATE_ABSENCES,
          DateTime.now().millisecondsSinceEpoch,
        );
        yield AbsencesUpdateLoaded();
      } on DioError catch (e, s) {
        FirebaseCrashlytics.instance.recordError(e, s);
        FLog.error(text: 'Updating asbences error ${e.toString()}');
        yield AbsencesUpdateError(e.response.data.toString());
      } on NotConntectedException catch (_) {
        yield AbsencesLoadErrorNotConnected();
      } catch (e, s) {
        FirebaseCrashlytics.instance.recordError(e, s);
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
        FirebaseCrashlytics.instance.recordError(e, s);
        FLog.error(text: 'Getting absences error ${e.toString()}');
        yield AbsencesError(e.toString());
      }
    }
  }
}
