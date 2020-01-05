import 'package:meta/meta.dart';

@immutable
abstract class SubjectsGradesEvent {}

///This gets both [grades] and [subjects]
class GetGradesAndSubjects extends SubjectsGradesEvent {}
