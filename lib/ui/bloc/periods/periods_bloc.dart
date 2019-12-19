import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
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
      try {
        await periodsRepository.updatePeriods();
        yield PeriodsUpdateLoaded();
      } on DioError catch (e) {
        yield PeriodsUpdateError(e.toString());
      }
    }

    // For getting periods
    if (event is GetPeriods) {
      yield PeriodsLoading();
      try {
        final periods = await periodsRepository.getAllPeriods();
        yield PeriodsLoaded(periods: periods);
      } catch (e) {
        yield PeriodsError(e.toString());
      }
    }
  }
}
