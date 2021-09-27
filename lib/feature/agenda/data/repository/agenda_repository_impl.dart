import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures.dart';
import 'package:registro_elettronico/core/infrastructure/error/handler.dart';
import 'package:registro_elettronico/core/infrastructure/error/successes.dart';
import 'package:registro_elettronico/core/infrastructure/generic/resource.dart';
import 'package:registro_elettronico/core/infrastructure/generic/update.dart';
import 'package:registro_elettronico/feature/agenda/data/datasource/local/agenda_local_datasource.dart';
import 'package:registro_elettronico/feature/agenda/data/datasource/remote/agenda_remote_datasource.dart';
import 'package:registro_elettronico/feature/agenda/data/model/agenda_event_local_model.dart';
import 'package:registro_elettronico/feature/agenda/data/model/agenda_event_remote_model.dart';
import 'package:registro_elettronico/feature/agenda/domain/model/agenda_data_domain_model.dart';
import 'package:registro_elettronico/feature/agenda/domain/model/agenda_event_domain_model.dart';
import 'package:registro_elettronico/feature/agenda/domain/repository/agenda_repository.dart';
import 'package:registro_elettronico/feature/lessons/data/datasource/lessons_local_datasource.dart';
import 'package:registro_elettronico/feature/lessons/domain/model/lesson_domain_model.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:registro_elettronico/utils/global_utils.dart';
import 'package:rxdart/rxdart.dart' hide Subject;
import 'package:shared_preferences/shared_preferences.dart';

class AgendaRepositoryImpl implements AgendaRepository {
  static const String lastUpdateKey = 'agendaLastUpdate';

  final AgendaLocalDatasource? agendaLocalDatasource;
  final AgendaRemoteDatasource? agendaRemoteDatasource;

  final LessonsLocalDatasource? lessonsLocalDatasource;

  final SharedPreferences? sharedPreferences;

  AgendaRepositoryImpl({
    required this.agendaLocalDatasource,
    required this.agendaRemoteDatasource,
    required this.sharedPreferences,
    required this.lessonsLocalDatasource,
  });

  @override
  Future<Either<Failure, Success>> deleteEvent({
    required AgendaEventDomainModel event,
  }) async {
    try {
      await agendaLocalDatasource!.deleteEventWithId(event.id);
      return Right(Success());
    } catch (e, s) {
      return Left(handleError('[AgendaRepository] Delete event error', e, s));
    }
  }

  @override
  Future<Either<Failure, Success>> insertEvent({
    required AgendaEventDomainModel event,
  }) async {
    try {
      await agendaLocalDatasource!.insertEvent(event.toLocalModel());
      return Right(Success());
    } catch (e, s) {
      return Left(handleError('[AgendaRepository] Insert event error', e, s));
    }
  }

  @override
  Future<Either<Failure, Success>> updateAgendaLatestDays({
    required bool ifNeeded,
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
      return Left(
          handleError('[AgendaRepository] Update latest days error', e, s));
    }
  }

  @override
  Future<Either<Failure, Success>> updateAllAgenda({
    required bool ifNeeded,
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
      return Left(
          handleError('[AgendaRepository] Update all agenda error', e, s));
    }
  }

  @override
  Future<Either<Failure, Success>> updateEvent({
    required AgendaEventDomainModel event,
  }) async {
    try {
      await agendaLocalDatasource!.updateEvent(event.toLocalModel());
      return Right(Success());
    } catch (e, s) {
      return Left(handleError('[AgendaRepository] Update event error', e, s));
    }
  }

  @override
  Stream<Resource<AgendaDataDomainModel>> watchAgendaData() async* {
    yield* Rx.combineLatest2(
      agendaLocalDatasource!.watchAllEvents(),
      lessonsLocalDatasource!.watchAllLessons(),
      (List<AgendaEventLocalModel> events, List<LessonLocalModel> lessons) {
        events.sort((a, b) => a.begin!.compareTo(b.begin!));
        final domainEvents = events
            .map((l) => AgendaEventDomainModel.fromLocalModel(l))
            .toList();

        final Map<DateTime?, List<AgendaEventDomainModel>> eventsMap =
            Map.fromIterable(
          events,
          key: (e) => e.begin,
          value: (e) => domainEvents
              .where((event) => SRDateUtils.areSameDay(event.begin!, e.begin))
              .toList(),
        );

        final domainLessons =
            lessons.map((l) => LessonDomainModel.fromLocalModel(l)).toList();

        final lessonsMap = groupBy<LessonDomainModel, String>(
          domainLessons,
          (e) => _convertDate(e.date!),
        );

        final eventsMapString = groupBy<AgendaEventDomainModel, String>(
          domainEvents,
          (e) => _convertDate(e.begin!),
        );

        final today = DateTime.now();

        // mette nella lista soltanto gli eventi di oggi o i prossimi
        final eventsList = domainEvents
            .where(
              (e) =>
                  e.begin!.isAfter(today) ||
                  (SRDateUtils.areSameDay(e.begin!, today) &&
                      DateTime.now().hour <= 14),
            )
            .toList();

        return Resource.success(
          data: AgendaDataDomainModel(
            eventsMap: eventsMap,
            lessonsMap: lessonsMap,
            events: eventsList,
            eventsMapString: eventsMapString,
            eventsSpots: _getEventsSpotsForDays(events: eventsMapString),
            lessons: domainLessons,
            allEvents: domainEvents,
          ),
        );
      },
    ).onErrorReturnWith((e, s) {
      return Resource.failed(
          error: handleError('[AgendaRepository] Agenda stream error', e, s));
    });
  }

  List<FlSpot> _getEventsSpotsForDays({
    required Map<String, List<AgendaEventDomainModel>> events,
  }) {
    List<FlSpot> spots = [];

    DateTime today = DateTime.now();
    DateTime firstDay;

    if (today.weekday == DateTime.saturday) {
      firstDay = today.add(Duration(days: 2));
    } else if (today.weekday == DateTime.sunday) {
      firstDay = today.add(Duration(days: 1));
    } else {
      firstDay = today.subtract(Duration(days: today.weekday - 1));
    }

    DateTime dayOfWeek = DateTime.utc(today.year, today.month, firstDay.day);
    String currentString;

    for (var i = 1; i <= 6; i++) {
      currentString = SRDateUtils.convertDate(dayOfWeek);
      final eventsForDay = events[currentString];
      final numberOfEvents = eventsForDay != null ? eventsForDay.length : 0;

      spots.add(FlSpot(i.toDouble(), numberOfEvents.toDouble()));
      dayOfWeek = dayOfWeek.add(Duration(days: 1));
    }

    return spots;
  }

  /// This returns the [max interval] to fetch all the lessons / agendas
  /// For example if it is november 2019 it fetches => sep 2019 to aug 2020
  _DateTimeInterval _getMaxDateInterval() {
    final now = DateTime.now();
    int yearBegin = now.year;
    int yearEnd = now.year;

    // if we are before sempember we need to fetch from the last year
    if (now.month >= DateTime.september) {
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
        (ifNeeded && needUpdate(sharedPreferences!.getInt(lastUpdateKey)));
  }

  Future<Success> _updateBetweenDates({
    required DateTime start,
    required DateTime end,
  }) async {
    final remoteAgendaEvents = await agendaRemoteDatasource!.getEvents(
      start: _convertDate(start),
      end: _convertDate(end),
    );

    final localAgendaEvents = await agendaLocalDatasource!.getAllEvents();

    final agendasMap = Map<int?, AgendaEventLocalModel?>.fromIterable(
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

    await agendaLocalDatasource!.insertEvents(
      remoteAgendaEvents
          .map(
            (e) => AgendaEventLocalModelConverter.fromRemoteModel(
              e,
              agendasMap[e.evtId],
              _eventColor(e),
            ),
          )
          .toList(),
    );

    // delete the agendas that were removed from the remote source
    await agendaLocalDatasource!.deleteEvents(agendasToDelete);

    await sharedPreferences!
        .setInt(lastUpdateKey, DateTime.now().millisecondsSinceEpoch);

    return SuccessWithUpdate();
  }
}

Color _eventColor(AgendaEventRemoteModel event) {
  Color color;
  if (GlobalUtils.isVerificaOrInterrogazione(event.notes!)) {
    color = Colors.red;
  } else {
    color = Colors.green;
  }
  return color;
}

class _DateTimeInterval {
  DateTime begin;
  DateTime end;

  _DateTimeInterval({required this.begin, required this.end});
}
