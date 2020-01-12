import 'package:meta/meta.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';

@immutable
abstract class AgendaDashboardState {}

class AgendaDashboardInitial extends AgendaDashboardState {}

class AgendaDashboardLoadInProgress extends AgendaDashboardState {}

class AgendaDashboardLoadSuccess extends AgendaDashboardState {
  final List<AgendaEvent> events;

  AgendaDashboardLoadSuccess({@required this.events});
}

class AgendaDashboardLoadError extends AgendaDashboardState {}
