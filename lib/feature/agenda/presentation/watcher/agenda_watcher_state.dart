part of 'agenda_watcher_bloc.dart';

@immutable
abstract class AgendaWatcherState {}

class AgendaWatcherInitial extends AgendaWatcherState {}

class AgendaWatcherLoading extends AgendaWatcherState {}

class AgendaWatcherLoadSuccess extends AgendaWatcherState {
  final AgendaDataDomainModel? agendaDataDomainModel;

  AgendaWatcherLoadSuccess({
    required this.agendaDataDomainModel,
  });
}

class AgendaWatcherFailure extends AgendaWatcherState {
  final Failure? failure;

  AgendaWatcherFailure({required this.failure});
}
