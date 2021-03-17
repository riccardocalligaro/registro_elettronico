import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures.dart';
import 'package:registro_elettronico/core/infrastructure/error/handler.dart';
import 'package:registro_elettronico/core/infrastructure/log/logger.dart';
import 'package:registro_elettronico/feature/absences/data/dao/absence_dao.dart';
import 'package:registro_elettronico/feature/agenda/data/datasource/local/agenda_local_datasource.dart';
import 'package:registro_elettronico/feature/agenda/domain/model/agenda_event_domain_model.dart';
import 'package:registro_elettronico/feature/grades/data/datasource/normal/grades_local_datasource.dart';
import 'package:registro_elettronico/feature/grades/domain/model/grade_domain_model.dart';
import 'package:registro_elettronico/feature/notes/data/dao/note_dao.dart';
import 'package:registro_elettronico/feature/periods/data/dao/periods_local_datasource.dart';
import 'package:registro_elettronico/feature/periods/domain/model/period_domain_model.dart';
import 'package:registro_elettronico/feature/stats/data/model/student_report.dart';
import 'package:registro_elettronico/feature/stats/domain/repository/stats_repository.dart';
import 'package:registro_elettronico/feature/subjects/data/datasource/subject_local_datasource.dart';
import 'package:registro_elettronico/feature/subjects/domain/model/subject_domain_model.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:registro_elettronico/utils/constants/registro_constants.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:registro_elettronico/utils/global_utils.dart';
import 'package:registro_elettronico/utils/grades_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatsRepositoryImpl implements StatsRepository {
  final GradesLocalDatasource gradeDao;
  final AbsenceDao absenceDao;
  final SubjectsLocalDatasource subjectsLocalDatasource;
  final PeriodsLocalDatasource periodsLocalDatasource;
  final NoteDao noteDao;
  final AgendaLocalDatasource agendaDao;
  final SharedPreferences sharedPreferences;

  StatsRepositoryImpl(
    this.gradeDao,
    this.absenceDao,
    this.subjectsLocalDatasource,
    this.periodsLocalDatasource,
    this.noteDao,
    this.agendaDao,
    this.sharedPreferences,
  );

  @override
  Future<Either<Failure, StudentReport>> getStudentReport() async {
    try {
      // We get the data that we need to get the stats
      final grades = await gradeDao.getGrades();

      final domainGrades =
          grades.map((l) => GradeDomainModel.fromLocalModel(l)).toList();

      final absences = await absenceDao.getAllAbsences();

      final localSubjects = await subjectsLocalDatasource.getAllSubjects();
      final subjects = localSubjects
          .map(
            (l) => SubjectDomainModel.fromLocalModel(
              professorsList: null,
              l: l,
              professorsSet: null,
            ),
          )
          .toList();

      final localPeriods = await periodsLocalDatasource.getPeriods();
      final periods = localPeriods
          .map(
            (l) => PeriodDomainModel.fromLocalModel(l),
          )
          .toList();

      final notes = await noteDao.getAllNotes();
      final localEvents = await agendaDao.getAllEvents();
      final events = localEvents
          .map((e) => AgendaEventDomainModel.fromLocalModel(e))
          .toList();

      final year = sharedPreferences.getInt(PrefsConstants.STUDENT_YEAR) ?? 3;

      if (periods.length >= 2) {
        double average = 0;
        double firstTermAverage = 0;
        double secondTermAverage = 0;

        int gradesCount = 0;
        int firstTermGradesCount = 0;
        int secondTermGradesCount = 0;

        PeriodDomainModel mostProfitablePeriod;

        // We get the best and worst subject
        SubjectDomainModel bestSubject;
        SubjectDomainModel worstSubject;
        double subjectAverage = 0.0;
        double maxAverage = -1.0;
        double minAverage = 11.0;

        int insufficienzeGraviCount = 0;
        int sufficienzeCount = 0;
        int insufficienzeLieviCount = 0;
        int insufficienzeCount = 0;

        List<SubjectDomainModel> insufficientiSubjects = [];
        List<SubjectDomainModel> sufficientiSubjects = [];

        int nearlySufficientiSubjectsCount = 0;
        int sufficientiSubjectsCount = 0;
        int insufficientiSubjectsCount = 0;
        int gravementeInsufficientiSubjectsCount = 0;

        subjects.forEach((subject) {
          subjectAverage = GradesUtils.getAverage(subject.id, domainGrades);
          if (subjectAverage > maxAverage) {
            bestSubject = subject;
            maxAverage = subjectAverage;
          }
          if (subjectAverage < minAverage && subjectAverage > 0.0) {
            worstSubject = subject;
            minAverage = subjectAverage;
          }

          if (subjectAverage >= 6) {
            sufficientiSubjectsCount++;
            sufficientiSubjects.add(subject);
          } else if (subjectAverage >= 5.5 && subjectAverage < 6) {
            nearlySufficientiSubjectsCount++;
            insufficientiSubjects.add(subject);
          } else if (subjectAverage >= 4.5) {
            insufficientiSubjectsCount++;
          } else if (!subjectAverage.isNaN && subjectAverage > 0.0) {
            insufficientiSubjects.add(subject);
            gravementeInsufficientiSubjectsCount++;
          }
        });

        domainGrades.forEach((grade) {
          if (GradesUtils.isValidGrade(grade)) {
            if (true) {
              average += grade.decimalValue;
              gradesCount++;

              if (grade.periodPos == periods.elementAt(0).position) {
                firstTermAverage += grade.decimalValue;
                firstTermGradesCount++;
              } else if (grade.periodPos == periods.elementAt(1).position) {
                secondTermAverage += grade.decimalValue;
                secondTermGradesCount++;
              }

              if (grade.decimalValue >= 6) {
                sufficienzeCount++;
              } else if (grade.decimalValue >= 5.5 && grade.decimalValue < 6) {
                insufficienzeLieviCount++;
              } else if (grade.decimalValue >= 4.5) {
                insufficienzeCount++;
              } else {
                insufficienzeGraviCount++;
              }
            }
          }
        });

        average = average / gradesCount;
        firstTermAverage = firstTermAverage / firstTermGradesCount;
        secondTermAverage = secondTermAverage / secondTermGradesCount;

        if (secondTermAverage > 0) {
          if (firstTermAverage >= secondTermAverage) {
            mostProfitablePeriod = periods.elementAt(0);
          } else {
            mostProfitablePeriod = periods.elementAt(1);
          }
        } else {
          mostProfitablePeriod = periods.elementAt(0);
        }

        final skippedTestsForAbsences = _getSkippedTests(
          absences: absences,
          events: events,
        );

        final daysRemaining =
            periods.elementAt(1).end.difference(DateTime.now());

        int schoolCredits;

        if (periods.elementAt(0).end.isAfter(DateTime.now())) {
          schoolCredits =
              GradesUtils.getMinSchoolCredits(firstTermAverage, year);
        } else {
          schoolCredits =
              GradesUtils.getMinSchoolCredits(secondTermAverage, year);
        }

        double score;
        try {
          score = _getUserScore(
            absences: absences,
            grades: domainGrades,
            notes: notes,
            skippedTests: skippedTestsForAbsences,
            average: average,
            nearlySufficientSubjects: nearlySufficientiSubjectsCount,
            insufficientSubjects: insufficientiSubjectsCount,
            events: events,
            nearlySufficientGrades: insufficienzeLieviCount,
            insufficientGrades: insufficienzeCount,
            sufficientGrades: sufficienzeCount,
            gravementeInsufficientGrades: insufficienzeGraviCount,
            totalGrades: gradesCount,
            gravementeInsufficientSubjects:
                gravementeInsufficientiSubjectsCount,
          );
        } catch (e, s) {
          handleError(e, s);
        }

        return Right(
          StudentReport(
            score: score ?? -1,
            average: average,
            firstTermAverage: firstTermAverage,
            secondTermAverage: secondTermAverage,
            mostProfitablePeriod: mostProfitablePeriod,
            bestSubject: bestSubject,
            worstSubject: worstSubject,
            insufficienzeGraviCount:
                insufficienzeGraviCount + insufficienzeCount,
            insufficienzeLieviCount: insufficienzeLieviCount,
            sufficienzeCount: sufficienzeCount,
            skippedTestsForAbsences: skippedTestsForAbsences,
            sufficientiSubjects: sufficientiSubjects,
            insufficientiSubjects: insufficientiSubjects,
            totalGrades: gradesCount,
            grades: domainGrades,
            absences: absences,
            subjects: subjects,
            periods: periods,
            timeRemainingToSchoolFinish: daysRemaining,
            agendaEvents: events,
            schoolCredits: schoolCredits,
            sufficientiSubjectsCount: sufficientiSubjectsCount,
            insufficientiSubjectsCount: insufficientiSubjectsCount +
                gravementeInsufficientiSubjectsCount,
            nearlySufficientiSubjectsCount: nearlySufficientiSubjectsCount,
          ),
        );
      } else {
        return Left(GenericFailure());
      }
    } catch (e, s) {
      Logger.e(
          text: 'Error calculating student report ${e.toString()}',
          stacktrace: s);
      return Left(GenericFailure());
    }
  }

  double _getUserScore({
    @required List<GradeDomainModel> grades,
    @required List<Absence> absences,
    @required List<Note> notes,
    @required int skippedTests,
    @required List<AgendaEventDomainModel> events,
    @required int nearlySufficientSubjects,
    @required int insufficientSubjects,
    @required double average,
    @required int sufficientGrades,
    @required int nearlySufficientGrades,
    @required int insufficientGrades,
    @required int gravementeInsufficientGrades,
    @required int totalGrades,
    @required int gravementeInsufficientSubjects,
  }) {
    double initialScore = sufficientGrades / totalGrades * 100.0;

    notes.forEach((note) => initialScore -= 10.0);

    for (var i = 0; i < nearlySufficientSubjects; i++) {
      initialScore -= 1.50;
    }
    for (var i = 0; i < insufficientSubjects; i++) {
      initialScore -= 2.50;
    }
    for (var i = 0; i < gravementeInsufficientSubjects; i++) {
      initialScore -= 3.50;
    }

    grades.forEach((g) {
      if (g.displayValue == '+') initialScore += 0.25;
      if (g.displayValue == '-') initialScore -= 0.25;
      if (g.displayValue == 'impr') initialScore -= 1;
    });

    absences.forEach((e) {
      if (e.evtCode == RegistroConstants.RITARDO_BREVE) initialScore -= 0.25;
      if (!e.isJustified) {
        initialScore -= 3.00;
      }
    });

    return initialScore >= 100 ? 100 : initialScore;
  }

  int _getSkippedTests({
    @required List<AgendaEventDomainModel> events,
    @required List<Absence> absences,
  }) {
    int days = 0;

    absences.forEach((absence) {
      final absenceDayEvents = events
          .where((e) => SRDateUtils.areSameDay(e.begin, absence.evtDate))
          .toList();

      // If there are events in the day of the event
      absenceDayEvents.forEach((dayEvent) {
        if (GlobalUtils.isVerificaOrInterrogazione(dayEvent.notes)) {
          if (absence.evtCode == RegistroConstants.ASSENZA) {
            days++;
          } else if (absence.evtCode == RegistroConstants.RITARDO) {
            if (absence.evtHPos > dayEvent.begin.hour - 8) {
              days++;
            }
          } else if (absence.evtCode == RegistroConstants.USCITA) {
            if (absence.evtHPos < dayEvent.begin.hour - 8) {
              days++;
            }
          }
        }
      });
    });

    return days;
  }
}
