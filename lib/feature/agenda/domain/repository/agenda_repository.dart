import 'package:dartz/dartz.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures.dart';
import 'package:registro_elettronico/core/infrastructure/error/successes.dart';
import 'package:registro_elettronico/core/infrastructure/generic/resource.dart';
import 'package:registro_elettronico/feature/agenda/domain/model/agenda_data_domain_model.dart';
import 'package:registro_elettronico/feature/agenda/domain/model/agenda_event_domain_model.dart';

abstract class AgendaRepository {
  Stream<Resource<AgendaDataDomainModel>> watchAgendaData();

  Future<Either<Failure, Success>> updateAllAgenda({required bool ifNeeded});

  Future<Either<Failure, Success>> updateAgendaLatestDays({
    required bool ifNeeded,
  });

  // Local events CRUD

  Future<Either<Failure, Success>> insertEvent({
    required AgendaEventDomainModel event,
  });

  Future<Either<Failure, Success>> updateEvent({
    required AgendaEventDomainModel event,
  });

  Future<Either<Failure, Success>> deleteEvent({
    required AgendaEventDomainModel event,
  });
}
