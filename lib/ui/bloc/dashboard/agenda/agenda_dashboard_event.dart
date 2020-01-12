import 'package:meta/meta.dart';

@immutable
abstract class AgendaDashboardEvent {}

class GetEvents extends AgendaDashboardEvent {}