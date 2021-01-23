import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures_v2.dart';
import 'package:registro_elettronico/feature/grades/domain/model/grade_domain_model.dart';
import 'package:registro_elettronico/feature/grades/domain/repository/grades_repository.dart';
import 'package:registro_elettronico/feature/subjects/domain/model/subject_domain_model.dart';

part 'grades_operations_event.dart';
part 'grades_operations_state.dart';

class GradesOperationsBloc
    extends Bloc<GradesOperationsEvent, GradesOperationsState> {
  final GradesRepository gradesRepository;

  GradesOperationsBloc({
    @required this.gradesRepository,
  }) : super(GradesOperationsInitial());

  @override
  Stream<GradesOperationsState> mapEventToState(
    GradesOperationsEvent event,
  ) async* {
    if (event is ToggleGradeLocallyCancelledState) {
      yield* _mapDeleteGradeLocallyToState(event);
    } else if (event is ChangeSubjectObjective) {
      yield* _mapChangeSubjectObjective(event);
    }
  }

  Stream<GradesOperationsState> _mapChangeSubjectObjective(
    ChangeSubjectObjective event,
  ) async* {
    final res = await gradesRepository.changeSubjectObjective(
      newValue: event.newValue,
      subject: event.subject,
    );

    yield* res.fold(
      (failure) async* {
        yield GradeOperationFailure(failure: failure);
      },
      (success) async* {
        yield GradeOperationSuccess();
      },
    );
  }

  Stream<GradesOperationsState> _mapDeleteGradeLocallyToState(
    ToggleGradeLocallyCancelledState event,
  ) async* {
    final res = await gradesRepository.toggleGradeLocallyCancelledStatus(
        gradeDomainModel: event.gradeDomainModel);

    yield* res.fold(
      (failure) async* {
        yield GradeOperationFailure(failure: failure);
      },
      (success) async* {
        yield GradeOperationSuccess();
      },
    );
  }
}
