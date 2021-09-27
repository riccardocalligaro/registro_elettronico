import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures.dart';
import 'package:registro_elettronico/feature/grades/domain/model/grades_section.dart';
import 'package:registro_elettronico/feature/grades/domain/model/subject_data_domain_model.dart';
import 'package:registro_elettronico/feature/grades/domain/repository/grades_repository.dart';

part 'subject_grades_pageset_event.dart';
part 'subject_grades_pageset_state.dart';

class SubjectGradesPagesetBloc
    extends Bloc<SubjectGradesPagesetEvent, SubjectGradesPagesetState> {
  final GradesRepository? gradesRepository;

  SubjectGradesPagesetBloc({
    required this.gradesRepository,
  }) : super(SubjectGradesPagesetInitial());

  @override
  Stream<SubjectGradesPagesetState> mapEventToState(
    SubjectGradesPagesetEvent event,
  ) async* {
    if (event is GetSubjectGradesPageset) {
      yield SubjectGradesPagesetLoading();

      final pageset = await gradesRepository!.getSubjectData(
        periodGradeDomainModel: event.periodGradeDomainModel,
      );

      yield* pageset.fold((failure) async* {
        yield SubjectGradesPagesetFailure(failure: failure);
      }, (pageset) async* {
        yield SubjectGradesPagesetLoaded(subjectDataDomainModel: pageset);
      });
    }
  }
}
