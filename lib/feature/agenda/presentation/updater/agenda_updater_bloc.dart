import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures_v2.dart';
import 'package:registro_elettronico/core/infrastructure/error/successes.dart';
import 'package:registro_elettronico/feature/agenda/domain/repository/agenda_repository.dart';

part 'agenda_updater_event.dart';
part 'agenda_updater_state.dart';

class AgendaUpdaterBloc extends Bloc<AgendaUpdaterEvent, AgendaUpdaterState> {
  final AgendaRepository? agendaRepository;

  AgendaUpdaterBloc({
    required this.agendaRepository,
  }) : super(AgendaUpdaterInitial());

  @override
  Stream<AgendaUpdaterState> mapEventToState(
    AgendaUpdaterEvent event,
  ) async* {
    if (event is UpdateAgendaIfNeeded) {
      yield AgendaUpdaterLoading();

      Either<Failure, Success> update;

      if (event.onlyLastDays) {
        update = await agendaRepository!.updateAgendaLatestDays(ifNeeded: true);
      } else {
        update = await agendaRepository!.updateAllAgenda(ifNeeded: true);
      }

      yield* update.fold((failure) async* {
        yield AgendaUpdaterFailure(failure: failure);
      }, (success) async* {
        yield AgendaUpdaterSuccess(success: success);
      });
    } else if (event is UpdateAgenda) {
      yield AgendaUpdaterLoading();

      Either<Failure, Success> update;

      if (event.onlyLastDays) {
        update = await agendaRepository!.updateAgendaLatestDays(ifNeeded: true);
      } else {
        update = await agendaRepository!.updateAllAgenda(ifNeeded: true);
      }

      yield* update.fold((failure) async* {
        yield AgendaUpdaterFailure(failure: failure);
      }, (success) async* {
        yield AgendaUpdaterSuccess(success: success);
      });
    }
  }
}
