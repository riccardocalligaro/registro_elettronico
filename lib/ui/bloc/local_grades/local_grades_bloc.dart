import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:registro_elettronico/domain/repository/grades_repository.dart';
import 'package:registro_elettronico/utils/constants/tabs_constants.dart';

import './bloc.dart';

class LocalGradesBloc extends Bloc<LocalGradesEvent, LocalGradesState> {
  GradesRepository gradesRepository;

  LocalGradesBloc(this.gradesRepository);

  @override
  LocalGradesState get initialState => LocalGradesInitial();

  @override
  Stream<LocalGradesState> mapEventToState(
    LocalGradesEvent event,
  ) async* {
    if (event is GetLocalGrades) {
      //yield LocalGradesLoading();
      final grades = await gradesRepository.getLocalGrades();
      if (event.period != TabsConstants.GENERALE) {
        yield LocalGradesLoaded(
            localGrades: grades
                .where(((grade) => grade.periodPos == event.period))
                .toList());
      } else {
        yield LocalGradesLoaded(localGrades: grades);
      }
    }

    if (event is AddLocalGrade) {
      await gradesRepository.insertLocalGrade(event.localGrade);
      final grades = await gradesRepository.getLocalGrades();
      yield LocalGradesLoaded(localGrades: grades);
    }
    if (event is DeleteLocalGrade) {
      //yield LocalGradesLoading();
      await gradesRepository.deleteLocalGrade(event.localGrade);
      final grades = await gradesRepository.getLocalGrades();
      yield LocalGradesLoaded(localGrades: grades);
    }
    if (event is UpdateLocalGrade) {
      //yield LocalGradesLoading();
      await gradesRepository.updateLocalGrade(event.localGrade);
      final grades = await gradesRepository.getLocalGrades();
      yield LocalGradesLoaded(localGrades: grades);
    }
  }
}
