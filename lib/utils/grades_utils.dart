import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/feature/grades/domain/model/grade_domain_model.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';

import 'constants/registro_constants.dart';
import 'entity/subject_averages.dart';

class GradesUtils {
  static double getDifferencePercentage({
    @required double oldAverage,
    @required double newAverage,
  }) {
    if (newAverage > 0 && oldAverage > 0) {
      return (newAverage - oldAverage) / oldAverage * 10;
    }
    return 0.0;
  }

  static double getAverage(int subjectId, List<GradeDomainModel> grades) {
    double sum = 0;
    int count = 0;

    int countAnnotaions = 0;
    grades.forEach((grade) {
      if (grade.decimalValue == -1.00 && grade.subjectId == subjectId) {
        countAnnotaions++;
      }

      if (grade.subjectId == subjectId && isValidGrade(grade)) {
        sum += grade.decimalValue;
        count++;
      }
    });
    final double avg = sum / count;

    if (countAnnotaions == 0 && avg.isNaN) {
      return -1.00;
    } else if (countAnnotaions > 0 && avg.isNaN) {
      return 0.0;
    }

    return avg;
  }

  static int getMinSchoolCredits(double average, int year) {
    if (year < 3) return 0;
    if (year == PrefsConstants.TERZA_SUPERIORE) {
      if (average < 6) return 0;
      if (average == 6) return 7;
      if (average > 6 && average <= 7) return 8;
      if (average > 7 && average <= 8) return 9;
      if (average > 8 && average <= 9) return 10;
      if (average > 9 && average <= 10) return 11;
    } else if (year == PrefsConstants.QUARTA_SUPERIORE) {
      if (average < 6) return 0;
      if (average == 6) return 8;
      if (average > 6 && average <= 7) return 9;
      if (average > 7 && average <= 8) return 10;
      if (average > 8 && average <= 9) return 11;
      if (average > 9 && average <= 10) return 12;
    } else if (year == PrefsConstants.QUINTA_SUPERIORE) {
      if (average < 6) return 7;
      if (average == 6) return 9;
      if (average > 6 && average <= 7) return 10;
      if (average > 7 && average <= 8) return 11;
      if (average > 8 && average <= 9) return 13;
      if (average > 9 && average <= 10) return 14;
    }

    return 0;
  }

  static double getAverageWithoutSubjectId(List<GradeLocalModel> grades) {
    double sum = 0;
    int count = 0;

    grades.forEach((grade) {
      if (grade.decimalValue != -1.00 ||
          grade.cancelled == true ||
          grade.localllyCancelled == true) {
        sum += grade.decimalValue;

        count++;
      }
    });
    return sum / count;
  }

  static SubjectAverages getSubjectAveragesFromGradeLocalModels(
      List<GradeDomainModel> grades, int subjectId) {
    // Declare variables for the different type of averages
    double sumAverage = 0;
    double countAverage = 0;

    double sumPratico = 0;
    double countPratico = 0;

    double sumOrale = 0;
    double countOrale = 0;

    double sumScritto = 0;
    double countScritto = 0;

    grades.forEach((grade) {
      final decimalValue = grade.decimalValue;
      if (isValidGrade(grade) && grade.subjectId == subjectId) {
        // always check the average for all grades
        sumAverage += decimalValue;
        countAverage++;
        // Orale
        if (grade.componentDesc == RegistroConstants.ORALE) {
          sumOrale += decimalValue;
          countOrale++;
        }
        // Scritto
        if (grade.componentDesc == RegistroConstants.SCRITTO) {
          sumScritto += decimalValue;
          countScritto++;
        }
        // Pratico
        if (grade.componentDesc == RegistroConstants.PRATICO) {
          sumPratico += decimalValue;
          countPratico++;
        }
      }
    });

    return SubjectAverages(
      average: sumAverage / countAverage,
      praticoAverage: sumPratico / countPratico,
      scrittoAverage: sumScritto / countScritto,
      oraleAverage: sumOrale / countOrale,
    );
  }

  static double getAverageForPratica(List<GradeLocalModel> grades) {
    double sum = 0;
    int count = 0;

    grades.forEach((grade) {
      if (grade.decimalValue != -1.00 &&
          grade.componentDesc == RegistroConstants.ORALE) {
        sum += grade.decimalValue;
        count++;
      }
    });
    return sum / count;
  }

  static bool isValidGrade(GradeDomainModel grade) {
    return (grade.decimalValue != -1.00 &&
        grade.cancelled == false &&
        grade.localllyCancelled == false);
  }

  static bool isValidLocalGradeLocalModel(GradeLocalModel grade) {
    return (grade.decimalValue != -1.00 || grade.cancelled != true);
  }
}
