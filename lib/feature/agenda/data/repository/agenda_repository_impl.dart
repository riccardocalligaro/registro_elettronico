import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures_v2.dart';
import 'package:registro_elettronico/core/infrastructure/error/handler.dart';
import 'package:registro_elettronico/core/infrastructure/error/successes.dart';
import 'package:registro_elettronico/core/infrastructure/generic/resource.dart';
import 'package:registro_elettronico/core/infrastructure/generic/update.dart';
import 'package:registro_elettronico/core/infrastructure/log/logger.dart';
import 'package:registro_elettronico/feature/agenda/data/datasource/local/agenda_local_datasource.dart';
import 'package:registro_elettronico/feature/agenda/data/datasource/remote/agenda_remote_datasource.dart';
import 'package:registro_elettronico/feature/agenda/data/model/agenda_event_local_model.dart';
import 'package:registro_elettronico/feature/agenda/domain/model/agenda_data_domain_model.dart';
import 'package:registro_elettronico/feature/agenda/domain/model/agenda_event_domain_model.dart';
import 'package:registro_elettronico/feature/agenda/domain/repository/agenda_repository.dart';
import 'package:registro_elettronico/feature/lessons/data/datasource/lessons_local_datasource.dart';
import 'package:registro_elettronico/feature/lessons/domain/model/lesson_domain_model.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:rxdart/rxdart.dart' hide Subject;
import 'package:shared_preferences/shared_preferences.dart';

class AgendaRepositoryImpl implements AgendaRepository {
  static const String lastUpdateKey = 'agendaLastUpdate';

  final AgendaLocalDatasource agendaLocalDatasource;
  final AgendaRemoteDatasource agendaRemoteDatasource;

  final LessonsLocalDatasource lessonsLocalDatasource;

  final SharedPreferences sharedPreferences;

  AgendaRepositoryImpl({
    @required this.agendaLocalDatasource,
    @required this.agendaRemoteDatasource,
    @required this.sharedPreferences,
    @required this.lessonsLocalDatasource,
  });

  @override
  Future<Either<Failure, Success>> deleteEvent({
    AgendaEventDomainModel event,
  }) async {
    try {
      await agendaLocalDatasource.deleteEventWithId(event.id);
      return Right(Success());
    } catch (e, s) {
      return Left(handleError(e, s));
    }
  }

  @override
  Future<Either<Failure, Success>> insertEvent({
    AgendaEventDomainModel event,
  }) async {
    try {
      await agendaLocalDatasource.insertEvent(event.toLocalModel());
      return Right(Success());
    } catch (e, s) {
      return Left(handleError(e, s));
    }
  }

  @override
  Future<Either<Failure, Success>> updateAgendaLatestDays({
    bool ifNeeded,
  }) async {
    try {
      if (_needUpdate(ifNeeded)) {
        // update the current events
        final now = DateTime.now();

        final update = await _updateBetweenDates(
            start: now.subtract(Duration(days: 7)), end: now);

        return Right(update);
      } else {
        return Right(SuccessWithoutUpdate());
      }
    } catch (e, s) {
      return Left(handleError(e, s));
    }
  }

  @override
  Future<Either<Failure, Success>> updateAllAgenda({
    bool ifNeeded,
  }) async {
    try {
      if (_needUpdate(ifNeeded)) {
        // update the current events
        final interval = _getMaxDateInterval();

        final update = await _updateBetweenDates(
          start: interval.begin,
          end: interval.end,
        );

        return Right(update);
      } else {
        return Right(SuccessWithoutUpdate());
      }
    } catch (e, s) {
      return Left(handleError(e, s));
    }
  }

  @override
  Future<Either<Failure, Success>> updateEvent({
    AgendaEventDomainModel event,
  }) async {
    try {
      await agendaLocalDatasource.updateEvent(event.toLocalModel());
      return Right(Success());
    } catch (e, s) {
      return Left(handleError(e, s));
    }
  }

  @override
  Stream<Resource<AgendaDataDomainModel>> watchAgendaData() async* {
    yield* Rx.combineLatest2(
      agendaLocalDatasource.watchAllEvents(),
      lessonsLocalDatasource.watchAllLessons(),
      (List<AgendaEventLocalModel> events, List<LessonLocalModel> lessons) {
        final domainEvents = events
            .map((l) => AgendaEventDomainModel.fromLocalModel(l))
            .toList();

        final eventsMap = groupBy<AgendaEventDomainModel, DateTime>(
          domainEvents,
          (e) => e.begin,
        );

        final domainLessons =
            lessons.map((l) => LessonDomainModel.fromLocalModel(l)).toList();

        final lessonsMap = groupBy<LessonDomainModel, String>(
          domainLessons,
          (e) => _convertDate(e.date),
        );

        final eventsMapString = groupBy<AgendaEventDomainModel, String>(
          domainEvents,
          (e) => _convertDate(e.begin),
        );

        final today = DateTime.now();

        // mette nella lista soltanto gli eventi di oggi o i prossimi
        final eventsList = domainEvents
            .where(
              (e) =>
                  e.begin.isAfter(today) ||
                  DateUtils.areSameDay(e.begin, today),
            )
            .toList();

        return Resource.success(
          data: AgendaDataDomainModel(
            eventsMap: eventsMap,
            lessonsMap: lessonsMap,
            events: eventsList,
            eventsMapString: eventsMapString,
          ),
        );
      },
    ).onErrorReturnWith((e) {
      return Resource.failed(error: handleStreamError(e));
    });
  }

  /// This returns the [max interval] to fetch all the lessons / agendas
  /// For example if it is november 2019 it fetches => sep 2019 to aug 2020
  _DateTimeInterval _getMaxDateInterval() {
    final now = DateTime.now();
    int yearBegin = now.year;
    int yearEnd = now.year;

    // if we are before sempember we need to fetch from the last year
    if (now.month > DateTime.september) {
      yearEnd += 1;
    } else {
      yearBegin -= 1;
    }

    final DateTime begin = DateTime.utc(yearBegin, DateTime.september, 1);
    final DateTime end = DateTime.utc(yearEnd, DateTime.august, 31);

    return _DateTimeInterval(begin: begin, end: end);
  }

  String _convertDate(DateTime date) {
    final formatter = DateFormat('yyyyMMdd');
    return formatter.format(date);
  }

  bool _needUpdate(bool ifNeeded) {
    return !ifNeeded |
        (ifNeeded && needUpdate(sharedPreferences.getInt(lastUpdateKey)));
  }

  Future<Success> _updateBetweenDates({
    @required DateTime start,
    @required DateTime end,
  }) async {
    final remoteAgendaEvents = await agendaRemoteDatasource.getEvents(
      start: _convertDate(start),
      end: _convertDate(end),
    );

    final localAgendaEvents = await agendaLocalDatasource.getAllEvents();

    final agendasMap = Map<int, AgendaEventLocalModel>.fromIterable(
        localAgendaEvents,
        key: (v) => v.evtId,
        value: (v) => v);

    final remoteIds = remoteAgendaEvents.map((e) => e.evtId).toList();

    List<AgendaEventLocalModel> agendasToDelete = [];

    for (final localAgendaEvent in localAgendaEvents) {
      if (!remoteIds.contains(localAgendaEvent.evtId)) {
        agendasToDelete.add(localAgendaEvent);
      }
    }

    await agendaLocalDatasource.insertEvents(
      remoteAgendaEvents
          .map(
            (e) => AgendaEventLocalModelConverter.fromRemoteModel(
              e,
              agendasMap[e.evtId],
            ),
          )
          .toList(),
    );

    // delete the agendas that were removed from the remote source
    await agendaLocalDatasource.deleteEvents(agendasToDelete);

    await sharedPreferences.setInt(
        lastUpdateKey, DateTime.now().millisecondsSinceEpoch);

    return SuccessWithUpdate();
  }
}

class _DateTimeInterval {
  DateTime begin;
  DateTime end;

  _DateTimeInterval({@required this.begin, @required this.end})
      : assert(begin != null && end != null);
}
