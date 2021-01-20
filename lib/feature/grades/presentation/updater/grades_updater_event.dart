part of 'grades_updater_bloc.dart';

@immutable
abstract class GradesUpdaterEvent {}

class UpdateGradesIfNeeded extends GradesUpdaterEvent {}

class UpdateGrades extends GradesUpdaterEvent {}
