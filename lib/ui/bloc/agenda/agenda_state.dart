import 'package:equatable/equatable.dart';

abstract class AgendaState extends Equatable {
  const AgendaState();

  @override
  List<Object> get props => [];
}

class AgendaInitial extends AgendaState {}

class AgendaLoading extends AgendaState {}

class AgendaLoaded extends AgendaState {}

class AgendaError extends AgendaState {
  final String message;

  AgendaError(this.message);
}
