part of 'subjects_grades_bloc.dart';

@immutable
abstract class SubjectsGradesEvent {}

///This gets both [grades] and [subjects]
class GetGradesAndSubjects extends SubjectsGradesEvent {}

class UpdateSubjectGrades extends SubjectsGradesEvent {}
