part of 'absences_bloc.dart';

abstract class AbsencesEvent extends Equatable {
  const AbsencesEvent();

  @override
  List<Object> get props => [];
}

class FetchAbsences extends AbsencesEvent {}

class GetAbsences extends AbsencesEvent {}
