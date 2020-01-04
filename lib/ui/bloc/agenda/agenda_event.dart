import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:registro_elettronico/ui/bloc/agenda/bloc.dart';

abstract class AgendaEvent extends Equatable {
  const AgendaEvent();

  @override
  List<Object> get props => [];
}

class UpdateAllAgenda extends AgendaEvent {}

class UpdateFromDate extends AgendaEvent {
  final DateTime date;

  UpdateFromDate({@required this.date});
}

class GetAllAgenda extends AgendaEvent {}

class GetNextEvents extends AgendaEvent {
  final int numberOfevents;
  final DateTime dateTime;

  GetNextEvents({
    @required this.numberOfevents,
    @required this.dateTime,
  });
}
