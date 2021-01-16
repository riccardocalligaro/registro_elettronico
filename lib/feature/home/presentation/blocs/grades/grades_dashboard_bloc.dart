import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:registro_elettronico/core/infrastructure/log/logger.dart';
import 'package:meta/meta.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/grades/domain/repository/grades_repository.dart';

part 'grades_dashboard_event.dart';
part 'grades_dashboard_state.dart';

class GradesDashboardBloc
    extends Bloc<GradesDashboardEvent, GradesDashboardState> {
  final GradesRepository gradesRepository;

  GradesDashboardBloc({
    @required this.gradesRepository,
  }) : super(GradesDashboardInitial());

  @override
  Stream<GradesDashboardState> mapEventToState(
    GradesDashboardEvent event,
  ) async* {
    if (event is GetDashboardGrades) {
      yield GradesDashboardLoadInProgress();
      try {
        Logger.info('BloC -> Getting dashboard grades');
        final grades = await gradesRepository.getNumberOfGradesByDate(3);

        Logger.info('BloC -> Got ${grades.length} grades for dashboard');
        yield GradesDashboardLoadSuccess(grades: grades);
      } catch (e) {
        Logger.e(text: 'Getting dashboard grades error');
        yield GradesDashboardLoadError();
      }
    }
  }
}
