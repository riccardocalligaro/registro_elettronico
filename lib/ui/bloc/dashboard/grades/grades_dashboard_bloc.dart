import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:f_logs/f_logs.dart';
import 'package:registro_elettronico/feature/grades/domain/repository/grades_repository.dart';
import './bloc.dart';

class GradesDashboardBloc
    extends Bloc<GradesDashboardEvent, GradesDashboardState> {
  GradesRepository gradesRepository;

  GradesDashboardBloc(this.gradesRepository);

  @override
  GradesDashboardState get initialState => GradesDashboardInitial();

  @override
  Stream<GradesDashboardState> mapEventToState(
    GradesDashboardEvent event,
  ) async* {
    if (event is GetDashboardGrades) {
      yield GradesDashboardLoadInProgress();
      try {
        FLog.info(text: 'BloC -> Getting dashboard grades');
        final grades = await gradesRepository.getNumberOfGradesByDate(3);

        FLog.info(text: 'BloC -> Got ${grades.length} grades for dashboard');
        yield GradesDashboardLoadSuccess(grades: grades);
      } catch (e) {
        FLog.error(text: 'Getting dashboard grades error');
        yield GradesDashboardLoadError();
      }
    }
  }
}
