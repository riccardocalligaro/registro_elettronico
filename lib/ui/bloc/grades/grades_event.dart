import 'package:equatable/equatable.dart';

abstract class GradesEvent extends Equatable {
  const GradesEvent();

  @override
  List<Object> get props => [];
}

/// This is only for updateing grades in the database
class UpdateGrades extends GradesEvent {}

/// This gets all the grades, in the state [grades] loaded
/// there is a [list] of grades
class GetGrades extends GradesEvent {
  final int limit;
  final bool ordered;

  GetGrades({this.limit, this.ordered});
}
