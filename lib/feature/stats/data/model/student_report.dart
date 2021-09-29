import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/agenda/domain/model/agenda_event_domain_model.dart';
import 'package:registro_elettronico/feature/grades/domain/model/grade_domain_model.dart';
import 'package:registro_elettronico/feature/periods/domain/model/period_domain_model.dart';
import 'package:registro_elettronico/feature/subjects/domain/model/subject_domain_model.dart';

/// A student report that contains useful information that is displayed
/// in the [report] section
class StudentReport {
  /// A custom [user] score that is calculated
  /// basing a lot of different parameters
  /// `0<=score<=100`
  final double score;

  /// The general average
  final double average;
  final double firstTermAverage;
  final double secondTermAverage;

  /// The period where the user has the best average
  final PeriodDomainModel mostProfitablePeriod;

  /// Overall best subject
  final SubjectDomainModel? bestSubject;

  /// Overall worst subject
  final SubjectDomainModel? worstSubject;

  // /// The [number] of max [consecutive]
  // /// sufficienze `grade >= 6`
  // final int maxConsecutiveSufficienze;

  // /// `grade < 6`
  // final int maxConsecutiveInsufficienze;

  /// count of grades where `grade < 5`
  final int insufficienzeGraviCount;

  /// count of grades where `5<grade<6`
  final int insufficienzeLieviCount;

  /// count of grades where `grade >= 6`
  final int sufficienzeCount;

  // /// [Max] number of days where student is absent
  // final int numberOfConsecutiveAbsences;

  /// Number of tests that the student skipped
  /// by not going to school
  final int skippedTestsForAbsences;

  /// Subjects where the average for the current period is `<5.5`
  final int insufficientiSubjectsCount;

  /// Subjects where the average for the current period is `5.5<x<6`
  final int nearlySufficientiSubjectsCount;

  /// Subjects where the average for the current period is `>6`
  final int sufficientiSubjectsCount;

  final List<SubjectDomainModel> insufficientiSubjects;

  final List<SubjectDomainModel> sufficientiSubjects;

  /// Total grades for the [first] and [second period]
  final int totalGrades;

  final List<GradeDomainModel> grades;

  final List<Absence> absences;

  final List<SubjectDomainModel> subjects;

  final List<PeriodDomainModel> periods;

  final List<AgendaEventDomainModel> agendaEvents;

  final Duration timeRemainingToSchoolFinish;

  final int schoolCredits;

  StudentReport({
    required this.score,
    required this.average,
    required this.firstTermAverage,
    required this.secondTermAverage,
    required this.mostProfitablePeriod,
    required this.bestSubject,
    required this.worstSubject,
    required this.insufficienzeGraviCount,
    required this.insufficienzeLieviCount,
    required this.sufficienzeCount,
    required this.skippedTestsForAbsences,
    required this.insufficientiSubjects,
    required this.sufficientiSubjects,
    required this.totalGrades,
    required this.grades,
    required this.absences,
    required this.subjects,
    required this.periods,
    required this.timeRemainingToSchoolFinish,
    required this.schoolCredits,
    required this.agendaEvents,
    required this.insufficientiSubjectsCount,
    required this.nearlySufficientiSubjectsCount,
    required this.sufficientiSubjectsCount,
  });

  @override
  String toString() {
    return 'StudentReport score: $score, average: $average, firstTermAverage: $firstTermAverage, secondTermAverage: $secondTermAverage, mostProfitablePeriod: $mostProfitablePeriod, bestSubject: $bestSubject, worstSubject: $worstSubject, insufficienzeGraviCount: $insufficienzeGraviCount, insufficienzeLieviCount: $insufficienzeLieviCount, sufficienzeCount: $sufficienzeCount, skippedTestsForAbsences: $skippedTestsForAbsences, insufficientiSubjectsCount: $insufficientiSubjectsCount, nearlySufficientiSubjectsCount: $nearlySufficientiSubjectsCount, sufficientiSubjectsCount: $sufficientiSubjectsCount, insufficientiSubjects: $insufficientiSubjects, sufficientiSubjects: $sufficientiSubjects, totalGrades: $totalGrades, grades: $grades, absences: $absences, subjects: $subjects, periods: $periods, agendaEvents: $agendaEvents, timeRemainingToSchoolFinish: $timeRemainingToSchoolFinish, schoolCredits: $schoolCredits';
  }
}
