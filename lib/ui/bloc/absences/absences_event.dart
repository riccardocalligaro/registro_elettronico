import 'package:equatable/equatable.dart';

abstract class AbsencesEvent extends Equatable {
  const AbsencesEvent();

  @override
  List<Object> get props => [];
}

class FetchAbsences extends AbsencesEvent {}
