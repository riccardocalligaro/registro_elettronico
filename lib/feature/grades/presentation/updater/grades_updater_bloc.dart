import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures_v2.dart';
import 'package:registro_elettronico/core/infrastructure/error/successes.dart';
import 'package:registro_elettronico/feature/grades/domain/repository/grades_repository.dart';

part 'grades_updater_event.dart';
part 'grades_updater_state.dart';

class GradesUpdaterBloc extends Bloc<GradesUpdaterEvent, GradesUpdaterState> {
  final GradesRepository gradesRepository;

  GradesUpdaterBloc({
    this.gradesRepository,
  }) : super(GradesUpdaterInitial());

  @override
  Stream<GradesUpdaterState> mapEventToState(
    GradesUpdaterEvent event,
  ) async* {
    if (event is UpdateGradesIfNeeded) {
      yield GradesUpdaterLoading();

      final update = await gradesRepository.updateGrades(ifNeeded: true);

      yield* update.fold((failure) async* {
        yield GradesUpdaterFailure(failure: failure);
      }, (success) async* {
        yield GradesUpdaterSuccess(success: success);
      });
    } else if (event is UpdateGrades) {
      yield GradesUpdaterLoading();

      final update = await gradesRepository.updateGrades(ifNeeded: false);

      yield* update.fold((failure) async* {
        yield GradesUpdaterFailure(failure: failure);
      }, (success) async* {
        yield GradesUpdaterSuccess(success: success);
      });
    }
  }
}
