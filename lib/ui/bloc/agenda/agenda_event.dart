import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

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
  final DateTime dateTime;

  GetNextEvents({
    @required this.dateTime,
  });
}
