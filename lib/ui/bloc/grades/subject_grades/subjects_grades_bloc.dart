import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:registro_elettronico/domain/repository/repositories_export.dart';
import './bloc.dart';

class SubjectsGradesBloc
    extends Bloc<SubjectsGradesEvent, SubjectsGradesState> {
  SubjectsRepository subjectsRepository;
  GradesRepository gradesRepository;

  SubjectsGradesBloc(this.subjectsRepository, this.gradesRepository);

  @override
  SubjectsGradesState get initialState => SubjectsGradesInitial();

  @override
  Stream<SubjectsGradesState> mapEventToState(
    SubjectsGradesEvent event,
  ) async* {
    if (event is GetGradesAndSubjects) {
      yield* _mapGetGradesAndSubjectsToState();
    } else if (event is UpdateSubjectGrades) {
      yield* _mapUpdateSubjectGradesToState();
    }
  }

  Stream<SubjectsGradesState> _mapGetGradesAndSubjectsToState() async* {
    //yield SubjectsGradesLoadInProgress();
    try {
      final subjects = await subjectsRepository.getAllSubjects();
      final grades = await gradesRepository.getAllGrades();
      yield SubjectsGradesLoadSuccess(subjects: subjects, grades: grades);
    } catch (e) {
      yield SubjectsGradesLoadError(error: e.toString());
    }
  }

  Stream<SubjectsGradesState> _mapUpdateSubjectGradesToState() async* {
    yield SubjectsGradesUpdateLoadInProgress();
    try {
      await gradesRepository.updateGrades();
      yield SubjectsGradesUpdateLoadSuccess();
    } catch (e) {
      yield SubjectsGradesLoadError(error: e.toString());
    }
  }
}
