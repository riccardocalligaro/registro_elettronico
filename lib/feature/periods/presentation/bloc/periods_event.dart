part of 'periods_bloc.dart';

@immutable
abstract class PeriodsEvent {}

class FetchPeriods extends PeriodsEvent {}

class GetPeriods extends PeriodsEvent {}
