import 'package:dartz/dartz.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures_v2.dart';
import 'package:registro_elettronico/core/infrastructure/error/handler.dart';
import 'package:registro_elettronico/core/infrastructure/error/successes.dart';
import 'package:registro_elettronico/core/infrastructure/generic/resource.dart';
import 'package:registro_elettronico/core/infrastructure/generic/update.dart';
import 'package:registro_elettronico/core/infrastructure/log/logger.dart';
import 'package:registro_elettronico/feature/agenda/data/datasource/local/agenda_local_datasource.dart';
import 'package:registro_elettronico/feature/grades/data/datasource/local/local_grades_local_datasource.dart';
import 'package:registro_elettronico/feature/grades/data/datasource/normal/grades_local_datasource.dart';
import 'package:registro_elettronico/feature/grades/data/datasource/normal/grades_remote_datasource.dart';
import 'package:registro_elettronico/feature/grades/data/model/grade_local_model.dart';
import 'package:registro_elettronico/feature/grades/domain/model/grade_domain_model.dart';
import 'package:registro_elettronico/feature/grades/domain/model/grades_section.dart';
import 'package:registro_elettronico/feature/grades/domain/model/subject_data_domain_model.dart';
import 'package:registro_elettronico/feature/grades/domain/repository/grades_repository.dart';
import 'package:registro_elettronico/feature/lessons/data/datasource/lessons_local_datasource.dart';
import 'package:registro_elettronico/feature/periods/data/dao/periods_local_datasource.dart';
import 'package:registro_elettronico/feature/periods/domain/model/period_domain_model.dart';
import 'package:registro_elettronico/feature/professors/data/datasource/professors_local_datasource.dart';
import 'package:registro_elettronico/feature/professors/domain/model/professor_domain_model.dart';
import 'package:registro_elettronico/feature/subjects/data/datasource/subject_local_datasource.dart';
import 'package:registro_elettronico/feature/subjects/domain/model/subject_domain_model.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:registro_elettronico/utils/constants/registro_constants.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:registro_elettronico/utils/global_utils.dart';
import 'package:rxdart/rxdart.dart' hide Subject;
import 'package:shared_preferences/shared_preferences.dart';

class GradesRepositoryImpl extends GradesRepository {
  static const String lastUpdateKey = 'gradesLastUpdate';

  final GradesRemoteDatasource gradesRemoteDatasource;
  final GradesLocalDatasource gradesLocalDatasource;

  final PeriodsLocalDatasource periodsLocalDatasource;
  final SubjectsLocalDatasource subjectsLocalDatasource;
  final ProfessorLocalDatasource professorLocalDatasource;
  final LocalGradesLocalDatasource localGradesLocalDatasource;
  final LessonsLocalDatasource lessonsLocalDatasource;

  final AgendaLocalDatasource agendaLocalDatasource;

  final SharedPreferences sharedPreferences;

  GradesRepositoryImpl({
    @required this.gradesRemoteDatasource,
    @required this.gradesLocalDatasource,
    @required this.sharedPreferences,
    @required this.periodsLocalDatasource,
    @required this.subjectsLocalDatasource,
    @required this.professorLocalDatasource,
    @required this.localGradesLocalDatasource,
    @required this.lessonsLocalDatasource,
    @required this.agendaLocalDatasource,
  });

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
  Stream<Resource<GradesPagesDomainModel>> watchAllGradesSections() {
    return Rx.combineLatest5(
      periodsLocalDatasource.watchAllPeriods(),
      subjectsLocalDatasource.watchAllSubjects(),
      gradesLocalDatasource.watchGrades(),
      agendaLocalDatasource.watchAllEvents(),
      lessonsLocalDatasource.watchAllLessons(),
      (
        List<PeriodLocalModel> localPeriods,
        List<SubjectLocalModel> localSubjects,
        List<GradeLocalModel> localGrades,
        List<AgendaEventLocalModel> localEvents,
        List<LessonLocalModel> localLessons,
      ) {
        if (localPeriods.isEmpty) {
          return Resource.success(data: null);
        }

        if (localPeriods.last.position != -1) {
          localPeriods.add(
            PeriodLocalModel(
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
        }

        final domainPeriods = localPeriods
            .map((e) => PeriodDomainModel.fromLocalModel(e))
            .toList();

        final domainSubjects = localSubjects
            .map(
              (l) => SubjectDomainModel.fromLocalModel(
                l: l,
                professorsList: null,
                professorsSet: null,
              ),
            )
            .toList();

        bool showAsending =
            sharedPreferences.getBool(PrefsConstants.SORTING_ASCENDING) ??
                false;

        Map<int, int> objectives = Map();

        final defaultObjective = sharedPreferences.getInt(
              PrefsConstants.OVERALL_OBJECTIVE,
            ) ??
            6;

        for (final mSubject in domainSubjects) {
          final obj = sharedPreferences.getInt('${mSubject.id}_objective') ??
              defaultObjective;
          objectives[mSubject.id] = obj;
        }

        localGrades.sort((b, a) => a.eventDate.compareTo(b.eventDate));

        List<GradeDomainModel> grades = localGrades
            .map((localModel) => GradeDomainModel.fromLocalModel(localModel))
            .toList();

        if (localEvents.isNotEmpty &&
            localLessons.isNotEmpty &&
            localSubjects.isNotEmpty) {
          Map<int, Set<String>> additionalProfessors = Map();

          final lastLessons = localLessons
              .where((l) =>
                  l.date.isAfter(DateTime.now().subtract(Duration(days: 45))))
              .toList();

          for (final lesson in lastLessons) {
            final list = additionalProfessors[lesson.subjectId];
            if (lesson.author != null) {
              if (list != null) {
                additionalProfessors[lesson.subjectId].add(lesson.author);
              } else {
                additionalProfessors[lesson.subjectId] = Set();
                additionalProfessors[lesson.subjectId].add(lesson.author);
              }
            }
          }

          // get the map
          final Map<String, List<AgendaEventLocalModel>> eventsMap =
              Map.fromIterable(
            localEvents,
            key: (e) => _convertDate(e.begin),
            value: (e) => localEvents
                .where((event) => DateUtils.areSameDay(event.begin, e.begin))
                .toList(),
          );

          // once we got the map we can check the grades
          for (final grade in grades) {
            if (grade.notesForFamily.isEmpty) {
              // check events for that day
              final eventsForThatDay = eventsMap[_convertDate(grade.eventDate)];

              if (eventsForThatDay == null) continue;

              for (final event in eventsForThatDay) {
                final professors = additionalProfessors[grade.subjectId];
                if (professors.contains(event.authorName)) {
                  if (GlobalUtils.isVerificaOrInterrogazione(
                      '${event.notes} ${event.title}')) {
                    grade.notesForFamily = '${event.notes} ${event.title}';
                    continue;
                  }
                }
              }
            }
          }
        }

        List<PeriodWithGradesDomainModel> gradesPeriods = [];
        List<GradeDomainModel> gradesForThisPeriod;
        List<GradeDomainModel> filteredGradesForThisPeriod;

        for (final period in domainPeriods) {
          if (period.position == -1) {
            gradesForThisPeriod = grades;
          } else {
            gradesForThisPeriod =
                grades.where((g) => g.periodPos == period.position).toList();
          }

          filteredGradesForThisPeriod =
              gradesForThisPeriod.where((g) => _isValidGrade(g)).toList();

          filteredGradesForThisPeriod
              .sort((b, a) => a.eventDate.compareTo(b.eventDate));

          final average = _getAverageForPeriod(grades: gradesForThisPeriod);

          final Map<int, GradeDomainModel> gradesMap = Map.fromIterable(
            gradesForThisPeriod,
            key: (g) => g.subjectId,
            value: (g) => g,
          );

          List<PeriodGradeDomainModel> periodGradeDomainModels = [];

          for (final subject in domainSubjects) {
            periodGradeDomainModels.add(
              _getGradePeriodDomainModel(
                gradesAndSubjectMap: gradesMap,
                subject: subject,
                grades: gradesForThisPeriod,
                objectives: objectives,
                numberOfFilteredGrades: filteredGradesForThisPeriod
                    .where((element) => element.subjectId == subject.id)
                    .length,
              ),
            );
          }

          if (showAsending) {
            periodGradeDomainModels
                .sort((a, b) => a.average.compareTo(b.average));
          } else {
            periodGradeDomainModels
                .sort((b, a) => a.average.compareTo(b.average));
          }

          final invertedFilteredGrades = filteredGradesForThisPeriod;
          invertedFilteredGrades
              .sort((a, b) => a.eventDate.compareTo(b.eventDate));

          gradesPeriods.add(
            PeriodWithGradesDomainModel(
              gradesForList: periodGradeDomainModels,
              period: period,
              average: average,
              grades: gradesForThisPeriod,
              normalSpots: _getNormalSpots(grades: invertedFilteredGrades),
              averageSpots: _getAverageSpots(grades: invertedFilteredGrades),
              overallObjective: defaultObjective,
              filteredGrades: filteredGradesForThisPeriod,
            ),
          );
        }

        final notSeenGrades = grades.where((g) => !g.hasSeenIt);
        final seenGrades = grades.where((g) => g.hasSeenIt);

        List<GradeDomainModel> dividedGrades = [
          ...notSeenGrades,
          ...seenGrades,
        ];

        GradesPagesDomainModel gradesPagesDomainModel = GradesPagesDomainModel(
          grades: dividedGrades,
          periodsWithGrades: gradesPeriods,
          periods: domainPeriods.length,
          newNotSeenGrades: notSeenGrades.length,
        );

        return Resource.success(data: gradesPagesDomainModel);
      },
    ).handleError((e, s) {
      Logger.e(exception: e, stacktrace: s);
    }).onErrorReturnWith(
      (e) {
        return Resource.failed(error: handleStreamError(e));
      },
    );
  }

  String _convertDate(DateTime date) {
    final formatter = DateFormat('yyyyMMdd');
    return formatter.format(date);
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
      if (_isValidGrade(grades[i])) {
        sum += grades[i].decimalValue;
        count++;
        average = sum / count;
        // with num.parse(average.toStringAsFixed(2)) we cut the decimal digits
        spots.add(FlSpot(
            i.toDouble(), num.tryParse(average.toStringAsFixed(2) ?? 0)));

        if (spots.length == 1) {
          spots.add(FlSpot(spots[0].x + 1, spots[0].y));
        }
      }
    }

    return spots;
  }

  List<FlSpot> _getNormalSpots({@required List<GradeDomainModel> grades}) {
    List<FlSpot> spots = List<FlSpot>();

    // if we don't want to see the average we want to see the single grades during that time
    for (int i = 0; i < grades.length; i++) {
      if (_isValidGrade(grades[i])) {
        spots.add(FlSpot(i.toDouble(), grades[i].decimalValue));
      }
    }

    if (spots.length == 1) {
      spots.add(FlSpot(spots[0].x + 1, spots[0].y));
    }

    return spots;
  }

  PeriodGradeDomainModel _getGradePeriodDomainModel({
    @required SubjectDomainModel subject,
    @required List<GradeDomainModel> grades,
    @required Map<int, GradeDomainModel> gradesAndSubjectMap,
    @required Map<int, int> objectives,
    @required int numberOfFilteredGrades,
  }) {
    final filteredSubjectGrades =
        grades.where((g) => g.subjectId == subject.id).toList();

    // grades di quella materia
    final average = _getSubjectAverage(
      grades: filteredSubjectGrades,
    );

    final objective = objectives[subject.id];

    final gradeNeededForObjective = _gradeNeededForObjective(
      average: average,
      obj: objective,
      numberOfGrades: numberOfFilteredGrades,
    );

    return PeriodGradeDomainModel(
      average: average,
      gradeNeededForObjective: gradeNeededForObjective,
      subject: subject,
      objective: objective,
      grades: filteredSubjectGrades,
    );
  }

  double _getSubjectAverage({
    @required List<GradeDomainModel> grades,
  }) {
    double sum = 0;
    int count = 0;

    int countAnnotaions = 0;
    grades.forEach((grade) {
      if (grade.decimalValue == -1.00) {
        countAnnotaions++;
      }

      if (_isValidGrade(grade)) {
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
        return GradeNeededDomainModel(message: GradeNeededMessage.dont_worry);
      }

      if (votiMinimi[0] <= obj) {
        return GradeNeededDomainModel(
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

  bool _isValidGrade(GradeDomainModel grade) {
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

  @override
  Future<Either<Failure, Success>> changeSubjectObjective({
    SubjectDomainModel subject,
    int newValue,
  }) async {
    try {
      await sharedPreferences.setInt('${subject.id}_objective', newValue);
      print('${subject.id}_objective');
      print(newValue.toString());
      return Right(Success());
    } catch (e) {
      return Left(handleError(e));
    }
  }

  @override
  Future<Either<Failure, SubjectDataDomainModel>> getSubjectData({
    @required PeriodGradeDomainModel periodGradeDomainModel,
  }) async {
    try {
      final professors = await professorLocalDatasource
          .getProfessorsForSubject(periodGradeDomainModel.subject.id);

      final lessons = await lessonsLocalDatasource.getAllLessons();

      Set<String> additionalProfessors = Set();

      final lastLessons = lessons
          .where((l) =>
              l.date.isAfter(DateTime.now().subtract(Duration(days: 45))))
          .toList();
      for (final lesson in lastLessons) {
        if (lesson.subjectId == periodGradeDomainModel.subject.id) {
          if (lesson.author != null) {
            additionalProfessors.add(lesson.author);
          }
        }
      }

      final domainProfessors = await professors
          .map(
            (l) => ProfessorDomainModel.fromLocalModel(l),
          )
          .toList();

      periodGradeDomainModel.subject.professorsSet = additionalProfessors;

      return Right(
        SubjectDataDomainModel(
          data: periodGradeDomainModel,
          professors: domainProfessors,
          averages: _getSubjectAverages(
            grades: periodGradeDomainModel.grades,
          ),
          averageSpots: _getAverageSpots(grades: periodGradeDomainModel.grades),
          normalSpots: _getNormalSpots(grades: periodGradeDomainModel.grades),
        ),
      );
    } catch (e, s) {
      return Left(handleStreamError(e, s));
    }
  }

  SubjectAveragesDomainModel _getSubjectAverages({
    @required List<GradeDomainModel> grades,
  }) {
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
      if (_isValidGrade(grade)) {
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

    return SubjectAveragesDomainModel(
      average: sumAverage / countAverage,
      praticoAverage: sumPratico / countPratico,
      scrittoAverage: sumScritto / countScritto,
      oraleAverage: sumOrale / countOrale,
    );
  }

  @override
  Stream<Resource<List<GradeDomainModel>>> watchLocalGrades({
    int subjectId,
    int periodPos,
  }) async* {
    yield* localGradesLocalDatasource
        .watchGradesForSubject(subjectId, periodPos)
        .map((localModels) {
      return Resource.success(
          data: localModels
              .map((localModel) => GradeDomainModel.fromLocalGrade(localModel))
              .toList());
    }).onErrorReturnWith(
      (e) {
        Logger.e(text: e.toString());
        return Resource.failed(error: e);
      },
    );
  }

  @override
  Future<Either<Failure, Success>> addLocalGrade({
    GradeDomainModel gradeDomainModel,
  }) async {
    try {
      final localGrade = gradeDomainModel.toLocalGrade();
      await localGradesLocalDatasource.insertGrade(localGrade);

      return Right(Success());
    } catch (e, s) {
      return Left(handleError(e, s));
    }
  }

  @override
  Future<Either<Failure, Success>> deleteLocalGrade({
    GradeDomainModel gradeDomainModel,
  }) async {
    try {
      await localGradesLocalDatasource
          .deleteGradeWithId(gradeDomainModel.evtId);

      return Right(Success());
    } catch (e, s) {
      return Left(handleError(e, s));
    }
  }
}
