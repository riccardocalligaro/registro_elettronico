import 'package:meta/meta.dart';

@immutable
abstract class StatsEvent {}

/// Gets the data needed for the stats page
class GetStudentStats extends StatsEvent {}

/// Updates [grades], [absences], [subjects?]
class UpdateStudentStats extends StatsEvent {}
