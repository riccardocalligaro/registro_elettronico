import 'package:f_logs/f_logs.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/infrastructure/error/handler.dart';
import 'package:registro_elettronico/core/infrastructure/generic/update.dart';
import 'package:registro_elettronico/core/infrastructure/log/logger.dart';
import 'package:registro_elettronico/core/infrastructure/network/network_info.dart';
import 'package:registro_elettronico/feature/grades/data/datasource/normal/grades_local_datasource.dart';
import 'package:registro_elettronico/feature/grades/data/datasource/normal/grades_remote_datasource.dart';
import 'package:registro_elettronico/feature/grades/data/model/grade_local_model.dart';
import 'package:registro_elettronico/feature/grades/data/model/overall_stats_domain_model.dart';
import 'package:registro_elettronico/feature/grades/domain/model/grades_section.dart';
import 'package:registro_elettronico/feature/grades/domain/model/grade_domain_model.dart';
import 'package:registro_elettronico/core/infrastructure/generic/resource.dart';
import 'package:registro_elettronico/core/infrastructure/error/successes.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures_v2.dart';
import 'package:dartz/dartz.dart';
import 'package:registro_elettronico/feature/grades/domain/repository/grades_repository.dart';
import 'package:registro_elettronico/feature/periods/data/dao/period_dao.dart';
import 'package:registro_elettronico/feature/subjects/data/dao/subject_dao.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart' hide Subject;

class GradesRepositoryImpl extends GradesRepository {
  static const String lastUpdateKey = 'gradesLastUpdate';

  final GradesRemoteDatasource gradesRemoteDatasource;
  final GradesLocalDatasource gradesLocalDatasource;
  final PeriodDao periodDao;

  final NetworkInfo networkInfo;
  final SharedPreferences sharedPreferences;

  final SubjectDao subjectDao;

  GradesRepositoryImpl({
    @required this.gradesRemoteDatasource,
    @required this.gradesLocalDatasource,
    @required this.networkInfo,
    @required this.sharedPreferences,
    @required this.periodDao,
    @required this.subjectDao,
  });

  @override
  Future<Either<Failure, GradeDomainModel>> getGrade(String id) async {}

  @override
  Future<Either<Failure, List<GradeDomainModel>>> getGrades() async {
    try {
      final grades = await gradesLocalDatasource.getGrades();
      return Right(grades
          .map(
            (e) => GradeDomainModel.fromLocalModel(e),
          )
          .toList());
    } catch (e) {
      return Left(handleError(e));
    }
  }

  @override
  Future<Either<Failure, Success>> updateGrades({bool ifNeeded}) async {
    try {
      if (!ifNeeded |
          (ifNeeded && needUpdate(sharedPreferences.getInt(lastUpdateKey)))) {
        final remoteGrades = await gradesRemoteDatasource.getGrades();

        final localGrades = await gradesLocalDatasource.getGrades();

        final gradesMap = Map<int, GradeLocalModel>.fromIterable(localGrades,
            key: (v) => v.evtId, value: (v) => v);

        // get the ids
        final remoteIds = remoteGrades.map((e) => e.evtId).toList();

        List<GradeLocalModel> gradesToDelete = [];

        for (final localGrade in localGrades) {
          if (!remoteIds.contains(localGrade.evtId)) {
            gradesToDelete.add(localGrade);
          }
        }

        await gradesLocalDatasource.insertGrades(
          remoteGrades
              .map(
                (e) => GradeLocalModelConverter.fromRemoteModel(
                  e,
                  gradesMap[e.evtId],
                  // se i voti locali non sono vuoti allora guarda se il voto
                  // c'è localmente, quindi
                  localGrades.isNotEmpty
                      // se diverso da null significa che è presente
                      ? (gradesMap[e.evtId] != null)
                      : true,
                ),
              )
              .toList(),
        );

        // delete the grades that were removed from the remote source
        await gradesLocalDatasource.deleteGrades(gradesToDelete);

        await sharedPreferences.setInt(
            lastUpdateKey, DateTime.now().millisecondsSinceEpoch);

        return Right(SuccessWithUpdate());
      }
      return Right(SuccessWithoutUpdate());
    } catch (e) {
      return Left(handleError(e));
    }
  }

  @override
  Stream<Resource<List<GradeDomainModel>>> watchAllGrades() async* {
    yield* gradesLocalDatasource.watchGrades().map((localModels) {
      return Resource.success(
          data: localModels
              .map((localModel) => GradeDomainModel.fromLocalModel(localModel))
              .toList());
    }).onErrorReturnWith(
      (e) {
        Logger.e(text: e.toString());
        return Resource.failed(error: e);
      },
    );
  }

  @override
  Stream<Resource<GradesPagesDomainModel>> watchAllGradesSections() async* {
    final periods = await periodDao.getAllPeriods();
    periods.add(
      Period(
        code: 'general',
        position: -1,
        description: 'Generale',
        isFinal: null,
        start: null,
        end: null,
        miurDivisionCode: null,
        periodIndex: null,
      ),
    );

    final subjects = await subjectDao.getAllSubjects();

    yield* gradesLocalDatasource.watchGrades().map((localGrades) {
      // dobbiamo convertire i modelli locali dividendoli in più periods

      Map<int, int> objectives = Map();

      final defaultObjective = sharedPreferences.getInt(
            PrefsConstants.OVERALL_OBJECTIVE,
          ) ??
          6;

      for (final mSubject in subjects) {
        final obj = sharedPreferences.getInt('${mSubject.id}_objective') ??
            defaultObjective;
        objectives[mSubject.id] = obj;
      }

      localGrades.sort((b, a) => a.eventDate.compareTo(b.eventDate));

      final grades = localGrades
          .map((localModel) => GradeDomainModel.fromLocalModel(localModel))
          .toList();

      List<PeriodWithGradesDomainModel> gradesPeriods = [];
      List<GradeDomainModel> gradesForThisPeriod;

      for (final period in periods) {
        if (period.position == -1) {
          gradesForThisPeriod = grades;
        } else {
          gradesForThisPeriod =
              grades.where((g) => g.periodPos == period.position).toList();
        }

        final average = _getAverageForPeriod(grades: gradesForThisPeriod);

        final Map<int, GradeDomainModel> gradesMap = Map.fromIterable(
          gradesForThisPeriod,
          key: (g) => g.subjectId,
          value: (g) => g,
        );

        List<PeriodGradeDomainModel> periodGradeDomainModels = [];

        for (final subject in subjects) {
          periodGradeDomainModels.add(
            _getGradePeriodDomainModel(
              gradesAndSubjectMap: gradesMap,
              subject: subject,
              grades: gradesForThisPeriod,
              objectives: objectives,
            ),
          );
        }

        gradesPeriods.add(
          PeriodWithGradesDomainModel(
            gradesForList: periodGradeDomainModels,
            period: period,
            average: average,
            grades: gradesForThisPeriod,
            normalSpots: _getNormalSpots(grades: gradesForThisPeriod),
            averageSpots: _getAverageSpots(grades: gradesForThisPeriod),
            overallObjective: defaultObjective,
          ),
        );
      }

      GradesPagesDomainModel gradesPagesDomainModel = GradesPagesDomainModel(
        grades: grades,
        periodsWithGrades: gradesPeriods,
      );

      return Resource.success(data: gradesPagesDomainModel);
    }).onErrorReturnWith(
      (e) {
        return Resource.failed(error: handleError(e));
      },
    );
  }

  List<FlSpot> _getAverageSpots({
    @required List<GradeDomainModel> grades,
  }) {
    List<FlSpot> spots = List<FlSpot>();

    // simple algorithm to calculate avg
    double sum = 0;
    int count = 0;
    double average;

    // good old for, rare these days
    for (int i = 0; i < grades.length; i++) {
      if (grades[i].decimalValue != -1.00) {
        sum += grades[i].decimalValue;
        count++;
        average = sum / count;
        // with num.parse(average.toStringAsFixed(2)) we cut the decimal digits
        spots.add(FlSpot(i.toDouble(), num.parse(average.toStringAsFixed(2))));
      }
      if (spots.length == 1) {
        spots.add(FlSpot(spots[0].x + 1, spots[0].y));
      }
    }

    return spots;
  }

  List<FlSpot> _getNormalSpots({@required List<GradeDomainModel> grades}) {
    List<FlSpot> spots = List<FlSpot>();

    // if we don't want to see the average we want to see the single grades during that time
    for (int i = 0; i < grades.length; i++) {
      if (grades[i].decimalValue != -1.00) {
        spots.add(FlSpot(i.toDouble(), grades[i].decimalValue));
      }
    }

    if (spots.length == 1) {
      spots.add(FlSpot(spots[0].x + 1, spots[0].y));
    }

    return spots;
  }

  PeriodGradeDomainModel _getGradePeriodDomainModel({
    @required Subject subject,
    @required List<GradeDomainModel> grades,
    @required Map<int, GradeDomainModel> gradesAndSubjectMap,
    @required Map<int, int> objectives,
  }) {
    // grades di quella materia
    final average = _getSubjectAverage(
      subjectId: subject.id,
      grades: grades,
    );

    print(objectives);

    final gradeNeededForObjective = _gradeNeededForObjective(
      average: average,
      obj: objectives[subject.id],
      numberOfGrades: grades.length,
    );

    return PeriodGradeDomainModel(
      average: average,
      gradeNeededForObjective: gradeNeededForObjective,
      subject: subject,
    );
  }

  double _getSubjectAverage({
    @required int subjectId,
    @required List<GradeDomainModel> grades,
  }) {
    double sum = 0;
    int count = 0;

    int countAnnotaions = 0;
    grades.forEach((grade) {
      if (grade.decimalValue == -1.00 && grade.subjectId == subjectId) {
        countAnnotaions++;
      }

      if (grade.subjectId == subjectId && _isValidGradeLocalModel(grade)) {
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

  GradeNeededDomainModel _gradeNeededForObjective({
    @required int obj,
    @required double average,
    @required int numberOfGrades,
  }) {
    if (average.isNaN) {
      return GradeNeededDomainModel(message: GradeNeededMessage.dont_worry);
    }
    if (obj > 10 || average > 10) {
      return GradeNeededDomainModel(
        message: GradeNeededMessage.calculation_error,
      );
    }
    if (obj >= 10 && average < obj) {
      return GradeNeededDomainModel(message: GradeNeededMessage.unreachable);
    }

    var array = [0.75, 0.5, 0.25, 0.0];
    var index = 0;
    double sommaVotiDaPrendere;
    var votiMinimi = [0.0, 0.0, 0.0, 0.0, 0.0];
    double diff;
    double diff2;
    double resto = 0.0;
    double parteIntera;
    double parteDecimale;
    try {
      do {
        index += 1;
        sommaVotiDaPrendere =
            obj * (numberOfGrades + index) - average * numberOfGrades;
      } while (sommaVotiDaPrendere / index > 10);
      var i = 0;
      while (i < index) {
        votiMinimi[i] = sommaVotiDaPrendere / index + resto;
        resto = 0.0;
        parteIntera = votiMinimi[i];
        parteDecimale = (votiMinimi[i] - parteIntera) * 100;
        if (parteDecimale != 25.0 &&
            parteDecimale != 50.0 &&
            parteDecimale != 75.0) {
          var k = 0;
          do {
            diff = votiMinimi[i] - (parteIntera + array[k]);
            k++;
          } while (diff < 0);
          votiMinimi[i] = votiMinimi[i] - diff;
          resto = diff;
        }
        if (votiMinimi[i] > 10) {
          diff2 = votiMinimi[i] - 10;
          votiMinimi[i] = 10.0;
          resto += diff2;
        }
        i += 1;
      }
      String returnString;

      if (votiMinimi[0] <= 0) {
        GradeNeededDomainModel(message: GradeNeededMessage.dont_worry);
      }

      if (votiMinimi[0] <= obj) {
        GradeNeededDomainModel(
          message: GradeNeededMessage.not_less_then,
          value: votiMinimi[0].toStringAsFixed(2),
        );
      } else {
        if (votiMinimi.where((voto) => voto != 0.0).length > 3) {
          return GradeNeededDomainModel(
              message: GradeNeededMessage.unreachable);
        }

        returnString = "";

        votiMinimi.where((votoMinimo) => votoMinimo != 0.0).forEach((voto) {
          returnString += "${voto.toStringAsFixed(2)}, ";
        });
        return GradeNeededDomainModel(
          message: GradeNeededMessage.get_at_lest,
          value: returnString,
        );
      }

      return GradeNeededDomainModel(
          message: GradeNeededMessage.calculation_error);
    } catch (e) {
      return GradeNeededDomainModel(message: GradeNeededMessage.unreachable);
    }
  }

  double _getAverageForPeriod({
    @required List<GradeDomainModel> grades,
  }) {
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

  bool _isValidGradeLocalModel(GradeDomainModel grade) {
    return (grade.decimalValue != -1.00 &&
        grade.cancelled == false &&
        grade.localllyCancelled == false);
  }

  @override
  Future<Either<Failure, Success>> toggleGradeLocallyCancelledStatus({
    GradeDomainModel gradeDomainModel,
  }) async {
    try {
      final localModel = gradeDomainModel.toLocalModel();
      await gradesLocalDatasource.updateGrade(
        localModel.copyWith(
            localllyCancelled: !gradeDomainModel.localllyCancelled),
      );

      return Right(Success());
    } catch (e, s) {
      return Left(handleError(e, s));
    }
  }
}
