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
  final Map<DateTime, List<TimetableEntry>> timetable;

  TimetableLoaded({
    @required this.timetable,
  });
}
