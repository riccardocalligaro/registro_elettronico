part of 'timetable_bloc.dart';

@immutable
abstract class TimetableState {}

class TimetableInitial extends TimetableState {}

class TimetableLoading extends TimetableState {}

class TimetableError extends TimetableState {
  final String error;
  TimetableError(this.error);
}

class TimetableLoaded extends TimetableState {
  final List<TimetableEntry> timetableEntries;
  final List<SubjectDomainModel> subjects;

  TimetableLoaded({
    @required this.timetableEntries,
    @required this.subjects,
  });
}
