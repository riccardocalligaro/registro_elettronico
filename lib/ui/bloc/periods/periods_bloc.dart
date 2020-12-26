import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/domain/repository/periods_repository.dart';
import './bloc.dart';

class PeriodsBloc extends Bloc<PeriodsEvent, PeriodsState> {
  PeriodsRepository periodsRepository;

  PeriodsBloc(this.periodsRepository);

  Stream<List<Period>> watchAllGrades() => periodsRepository.watchAllPeriods();

  @override
  PeriodsState get initialState => PeriodsInitial();

  @override
  Stream<PeriodsState> mapEventToState(
    PeriodsEvent event,
  ) async* {
    if (event is FetchPeriods) {
      yield PeriodsUpdateLoading();
      FLog.info(text: 'Updating periods');
      try {
        await periodsRepository.updatePeriods();
        yield PeriodsUpdateLoaded();
      } on DioError catch (e) {
        yield PeriodsUpdateError(e.toString());
      } on Exception catch (e, s) {
        FLog.error(
          text: 'Error updating periods',
          exception: e,
          stacktrace: s,
        );
        FirebaseCrashlytics.instance.recordError(e, s);
      }
    }

    // For getting periods
    if (event is GetPeriods) {
      yield PeriodsLoading();
      try {
        final periods = await periodsRepository.getAllPeriods();
        yield PeriodsLoaded(periods: periods);
      } on Exception catch (e, s) {
        FLog.error(
          text: 'Error getting all periods',
          exception: e,
          stacktrace: s,
        );
        FirebaseCrashlytics.instance.recordError(e, s);
        yield PeriodsError(e.toString());
      }
    }
  }
}
