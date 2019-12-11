import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:registro_elettronico/data/db/dao/subject_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import './bloc.dart';

class SubjectsBloc extends Bloc<SubjectsEvent, SubjectsState> {
  SubjectDao subjectDao;

  @override
  SubjectsState get initialState => SubjectsInitialState();

  Stream<List<Subject>> get lessons => subjectDao.watchAllSubjects();

  @override
  Stream<SubjectsState> mapEventToState(
    SubjectsEvent event,
  ) async* {
    // todo: add fetch subjects, this will update subjects and professors
  }
}
