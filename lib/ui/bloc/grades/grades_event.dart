import 'package:equatable/equatable.dart';

abstract class GradesEvent extends Equatable {
  const GradesEvent();

  @override
  List<Object> get props => [];
}

/// This is only for updateing grades in the database
class FetchGrades extends GradesEvent {}

/// This gets all the grades, in the state [grades] loaded
/// there is a [list] of grades
class GetGrades extends GradesEvent {}

///This gets both [grades] and [subjects]
class GetGradesAndSubjects extends GradesEvent {}
