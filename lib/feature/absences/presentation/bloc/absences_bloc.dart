import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:registro_elettronico/core/infrastructure/log/logger.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures.dart';
import 'package:registro_elettronico/feature/absences/domain/repository/absences_repository.dart';

part 'absences_event.dart';
part 'absences_state.dart';

class AbsencesBloc extends Bloc<AbsencesEvent, AbsencesState> {
  final AbsencesRepository? absencesRepository;

  AbsencesBloc({
    required this.absencesRepository,
  }) : super(AbsencesInitial());

  @override
  Stream<AbsencesState> mapEventToState(
    AbsencesEvent event,
  ) async* {
    if (event is FetchAbsences) {
      yield AbsencesUpdateLoading();
      try {
        await absencesRepository!.updateAbsences();

        yield AbsencesUpdateLoaded();
      } on DioError catch (e, s) {
        await FirebaseCrashlytics.instance.recordError(e, s);
        Logger.e(text: 'Updating asbences error ${e.toString()}');
        yield AbsencesUpdateError(e.response!.data.toString());
      } on NotConntectedException catch (_) {
        yield AbsencesLoadErrorNotConnected();
      } catch (e, s) {
        await FirebaseCrashlytics.instance.recordError(e, s);
        Logger.e(text: 'Updating absences error ${e.toString()}');
        yield AbsencesUpdateError(e.toString());
      }
    }

    if (event is GetAbsences) {
      yield AbsencesLoading();
      try {
        final absences = await absencesRepository!.getAllAbsences();
        Fimber.i('BloC -> Got ${absences.length} absences');
        yield AbsencesLoaded(absences: absences);
      } catch (e, s) {
        await FirebaseCrashlytics.instance.recordError(e, s);
        Logger.e(text: 'Getting absences error ${e.toString()}');
        yield AbsencesError(e.toString());
      }
    }
  }
}
