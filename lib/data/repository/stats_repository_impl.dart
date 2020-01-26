import 'package:dartz/dartz.dart';
import 'package:f_logs/f_logs.dart';
import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/error/failures.dart';
import 'package:registro_elettronico/data/db/dao/absence_dao.dart';
import 'package:registro_elettronico/data/db/dao/agenda_dao.dart';
import 'package:registro_elettronico/data/db/dao/grade_dao.dart';
import 'package:registro_elettronico/data/db/dao/note_dao.dart';
import 'package:registro_elettronico/data/db/dao/period_dao.dart';
import 'package:registro_elettronico/data/db/dao/subject_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/domain/entity/student_report.dart';
import 'package:registro_elettronico/domain/repository/stats_repository.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:registro_elettronico/utils/constants/registro_constants.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:registro_elettronico/utils/grades_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatsRepositoryImpl implements StatsRepository {
  // Local Data sources
  GradeDao gradeDao;
  AbsenceDao absenceDao;
  SubjectDao subjectDao;
  PeriodDao periodDao;
  NoteDao noteDao;
  AgendaDao agendaDao;

  StatsRepositoryImpl(
    this.gradeDao,
    this.absenceDao,
    this.subjectDao,
    this.periodDao,
    this.noteDao,
    this.agendaDao,
  );

  @override
  Future<Either<Failure, StudentReport>> getStudentReport() async {
    try {
      // We get the data that we need to get the stats
      final grades = await gradeDao.getAllGrades();
      final absences = await absenceDao.getAllAbsences();
      final subjects = await subjectDao.getAllSubjects();
      final periods = await periodDao.getAllPeriods();
      final notes = await noteDao.getAllNotes();
      final events = await agendaDao.getAllEvents();

      SharedPreferences prefs = await SharedPreferences.getInstance();

      final year = prefs.getInt(PrefsConstants.STUDENT_YEAR) ?? 3;

      if (periods.length >= 2) {
        final score = _getUserScore(grades: grades, notes: notes);

        double average = 0;
        double firstTermAverage = 0;
        double secondTermAverage = 0;

        int gradesCount = 0;
        int firstTermGradesCount = 0;
        int secondTermGradesCount = 0;

        Period mostProfitablePeriod;

        // We get the best and worst subject
        Subject bestSubject;
        Subject worstSubject;
        double subjectAverage = 0.0;
        double maxAverage = -1.0;
        double minAverage = 11.0;

        int insufficienzeGraviCount = 0;
        int sufficienzeCount = 0;
        int insufficienzeLieviCount = 0;

        List<Subject> insufficientiSubjects = [];
        List<Subject> sufficientiSubjects = [];

        int nearlySufficientiSubjectsCount = 0;
        int sufficientiSubjectsCount = 0;
        int insufficientiSubjectsCount = 0;

        subjects.forEach((subject) {
          subjectAverage = GradesUtils.getAverage(subject.id, grades);
          if (subjectAverage > maxAverage) {
            bestSubject = subject;
            maxAverage = subjectAverage;
          } else if (subjectAverage < minAverage) {
            worstSubject = subject;
            minAverage = subjectAverage;
          }

          if (subjectAverage >= 6) {
            sufficientiSubjectsCount++;
            sufficientiSubjects.add(subject);
          } else if (subjectAverage >= 5.5 && subjectAverage < 6) {
            nearlySufficientiSubjectsCount++;
            insufficientiSubjects.add(subject);
          } else if (!subjectAverage.isNaN) {
            insufficientiSubjects.add(subject);
            insufficientiSubjectsCount++;
          }
        });

        grades.forEach((grade) {
          if (GradesUtils.isValidGrade(grade)) {
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
            } else {
              insufficienzeGraviCount++;
            }
          }
        });

        average = average / gradesCount;
        firstTermAverage = firstTermAverage / firstTermGradesCount;
        secondTermAverage = secondTermAverage / secondTermGradesCount;

        if (firstTermAverage >= secondTermAverage) {
          mostProfitablePeriod = periods.elementAt(0);
        } else {
          mostProfitablePeriod = periods.elementAt(1);
        }

        final skippedTestsForAbsences = _getSkippedTests(
          absences: absences,
          events: events,
        );

        final daysRemaining =
            periods.elementAt(1).end.difference(DateTime.now());

        final schoolCredits = GradesUtils.getMinSchoolCredits(average, year);

        return Right(
          StudentReport(
            score: score,
            average: average,
            firstTermAverage: firstTermAverage,
            secondTermAverage: secondTermAverage,
            mostProfitablePeriod: mostProfitablePeriod,
            bestSubject: bestSubject,
            worstSubject: worstSubject,
            insufficienzeGraviCount: insufficienzeGraviCount,
            insufficienzeLieviCount: insufficienzeLieviCount,
            sufficienzeCount: sufficienzeCount,
            skippedTestsForAbsences: skippedTestsForAbsences,
            sufficientiSubjects: sufficientiSubjects,
            insufficientiSubjects: insufficientiSubjects,
            totalGrades: gradesCount,
            grades: grades,
            absences: absences,
            subjects: subjects,
            periods: periods,
            timeRemainingToSchoolFinish: daysRemaining,
            agendaEvents: events,
            schoolCredits: schoolCredits,
            sufficientiSubjectsCount: sufficientiSubjectsCount,
            insufficientiSubjectsCount: insufficientiSubjectsCount,
            nearlySufficientiSubjectsCount: nearlySufficientiSubjectsCount,
          ),
        );
      } else {
        return Left(GenericFailure());
      }
    } catch (e, s) {
      FLog.error(
          text: 'Error calculating student report ${e.toString()}',
          stacktrace: s);
      return Left(GenericFailure());
    }
  }

  double _getUserScore({
    @required List<Grade> grades,
    @required List<Note> notes,
  }) {
    // TODO: better algorithm

    double initialScore = 100.0;

    notes.forEach((note) => initialScore -= 2.50);

    grades
        .where((g) => g.decimalValue < 5)
        .forEach((g) => initialScore -= 2.50);

    return initialScore;
  }

  int _getSkippedTests({
    @required List<AgendaEvent> events,
    @required List<Absence> absences,
  }) {
    int days = 0;

    absences.forEach((absence) {
      final absenceDayEvents = events
          .where((e) => DateUtils.areSameDay(e.begin, absence.evtDate))
          .toList();

      // If there are events in the day of the event
      // TODO: test
      absenceDayEvents.forEach((dayEvent) {
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
      });
    });

    return days;
  }
}
