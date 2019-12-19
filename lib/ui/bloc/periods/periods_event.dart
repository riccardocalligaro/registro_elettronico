import 'package:equatable/equatable.dart';

abstract class PeriodsEvent extends Equatable {
  const PeriodsEvent();

  @override
  List<Object> get props => [];
}

class FetchPeriods extends PeriodsEvent {}

class GetPeriods extends PeriodsEvent {}
