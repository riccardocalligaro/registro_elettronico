import 'package:flutter/material.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';

abstract class AgendaState {
  const AgendaState();

}

class AgendaInitial extends AgendaState {}

// Updates
class AgendaUpdateLoadInProgress extends AgendaState {}

class AgendaUpdateLoadSuccess extends AgendaState {}

// Updates
class AgendaLoadInProgress extends AgendaState {}

class AgendaLoadSuccess extends AgendaState {

  final Map<DateTime, List<AgendaEvent>> eventsMap;
  final List<AgendaEvent> events;
  
  const AgendaLoadSuccess({@required this.events, @required this.eventsMap});
}

class AgendaLoadErrorNotConnected extends AgendaState {}

class AgendaLoadError extends AgendaState {
  final String error;
  const AgendaLoadError({@required this.error});
}
