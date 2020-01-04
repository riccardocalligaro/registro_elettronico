import 'package:meta/meta.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';

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
  final List<Subject> subjects;

  TimetableLoaded({
    @required this.timetableEntries,
    @required this.subjects,
  });
}
