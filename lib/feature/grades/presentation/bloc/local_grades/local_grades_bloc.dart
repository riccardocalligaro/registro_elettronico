import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:registro_elettronico/core/infrastructure/log/logger.dart';
import 'package:meta/meta.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/grades/domain/repository/grades_repository.dart';
import 'package:registro_elettronico/utils/constants/tabs_constants.dart';

part 'local_grades_event.dart';
part 'local_grades_state.dart';

class LocalGradesBloc extends Bloc<LocalGradesEvent, LocalGradesState> {
  final GradesRepository gradesRepository;

  LocalGradesBloc({
    @required this.gradesRepository,
  }) : super(LocalGradesInitial());

  @override
  Stream<LocalGradesState> mapEventToState(
    LocalGradesEvent event,
  ) async* {
    if (event is GetLocalGrades) {
      //yield LocalGradesLoading();
      final grades = await gradesRepository.getLocalGrades();
      Logger.info('BloC -> Got ${grades.length} grades (not for period)');

      if (event.period != TabsConstants.GENERALE) {
        if (event.subjectId != null) {
          yield LocalGradesLoaded(
            localGrades: grades
                .where(((g) =>
                    g.periodPos == event.period &&
                    g.subjectId == event.subjectId))
                .toList(),
          );
        } else {
          yield LocalGradesLoaded(
            localGrades: grades
                .where(((grade) => grade.periodPos == event.period))
                .toList(),
          );
        }
      } else {
        if (event.subjectId != null) {
          yield LocalGradesLoaded(
              localGrades:
                  grades.where((g) => g.subjectId == event.subjectId).toList());
        } else {
          yield LocalGradesLoaded(
            localGrades: grades,
          );
        }
      }
    }

    if (event is AddLocalGrade) {
      await gradesRepository.insertLocalGrade(event.localGrade);
      Logger.info('Inserted grade ${event.localGrade.toString()}');
      final grades = await gradesRepository.getLocalGrades();
      yield LocalGradesLoaded(localGrades: grades);
    }

    if (event is DeleteLocalGrade) {
      await gradesRepository.deleteLocalGrade(event.localGrade);
      Logger.info('Deleted local grade ${event.localGrade.toString()}');

      final grades = await gradesRepository.getLocalGrades();
      yield LocalGradesLoaded(localGrades: grades);
    }
    if (event is UpdateLocalGrade) {
      await gradesRepository.updateLocalGrade(event.localGrade);
      Logger.info('Updated local grade ${event.localGrade.toString()}');

      final grades = await gradesRepository.getLocalGrades();
      yield LocalGradesLoaded(localGrades: grades);
    }
  }
}
