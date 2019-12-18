import 'package:equatable/equatable.dart';

abstract class AbsencesState extends Equatable {
  const AbsencesState();

  @override
  List<Object> get props => [];
}

class AbsencesInitial extends AbsencesState {}

class AbsencesLoading extends AbsencesState {}

class AbsencesLoaded extends AbsencesState {}

class AbsencesError extends AbsencesState {
  final String message;

  AbsencesError(this.message);
}
