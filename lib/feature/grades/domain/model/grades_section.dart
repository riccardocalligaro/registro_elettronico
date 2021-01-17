import 'package:collection/collection.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/grades/domain/model/grade_domain_model.dart';

class GradeSectionDomainModel {
  List<GradeDomainModel> grades;
  List<PeriodWithGrades> periodsWithGrades;

  GradeSectionDomainModel({
    this.grades,
    this.periodsWithGrades,
  });
}

class PeriodWithGrades {
  List<GradeDomainModel> grades;
  Period period;

  PeriodWithGrades({
    this.grades,
    this.period,
  });
}
