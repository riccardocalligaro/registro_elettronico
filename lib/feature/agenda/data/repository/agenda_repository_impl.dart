import 'package:f_logs/f_logs.dart';
import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/data/remote/api/spaggiari_client.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures.dart';
import 'package:registro_elettronico/core/infrastructure/network/network_info.dart';
import 'package:registro_elettronico/feature/agenda/data/dao/agenda_dao.dart';
import 'package:registro_elettronico/feature/agenda/data/model/event_mapper.dart';
import 'package:registro_elettronico/feature/agenda/domain/repository/agenda_repository.dart';
import 'package:registro_elettronico/feature/profile/data/dao/profile_dao.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:registro_elettronico/utils/global_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AgendaRepositoryImpl implements AgendaRepository {
  SpaggiariClient spaggiariClient;
  AgendaDao agendaDao;
  ProfileDao profileDao;
  NetworkInfo networkInfo;
  final SharedPreferences sharedPreferences;

  AgendaRepositoryImpl(
    this.spaggiariClient,
    this.agendaDao,
    this.profileDao,
    this.networkInfo,
    this.sharedPreferences,
  );

  @override
  Future updateAgendaBetweenDates(DateTime begin, DateTime end) async {
    if (await networkInfo.isConnected) {
      final profile = await profileDao.getProfile();

      final beginDate = DateUtils.convertDate(begin);
      final endDate = DateUtils.convertDate(end);
      List<AgendaEvent> events = [];

      final agenda = await spaggiariClient.getAgenda(
          profile.studentId, beginDate, endDate);

      Color color;
      agenda.events.forEach((event) {
        if (GlobalUtils.isVerificaOrInterrogazione(event.notes)) {
          color = Colors.red;
        } else {
          color = Colors.green;
        }
        events.add(EventMapper.convertEventEntityToInsertable(event, color));
      });

      FLog.info(
        text:
            'Got ${agenda.events.length} events from server, procceding to insert in database',
      );
      await agendaDao.deleteAllEventsWithoutLocal();

      await agendaDao.insertEvents(events);

      await sharedPreferences.setInt(
        PrefsConstants.lastUpdateAgenda,
        DateTime.now().millisecondsSinceEpoch,
      );
    } else {
      throw NotConntectedException();
    }
  }

  @override
  Future updateAgendaStartingFromDate(DateTime begin) async {
    if (await networkInfo.isConnected) {
      final profile = await profileDao.getProfile();

      final now = DateUtils.convertDate(DateTime.now());
      final interval = DateUtils.getDateInerval();
      final agenda =
          await spaggiariClient.getAgenda(profile.studentId, now, interval.end);
      List<AgendaEvent> events = [];

      Color color;

      agenda.events.forEach((event) {
        if (GlobalUtils.isVerificaOrInterrogazione(event.notes)) {
          color = Colors.red;
        } else {
          color = Colors.green;
        }
        events.add(EventMapper.convertEventEntityToInsertable(event, color));
      });
      await agendaDao.deleteEventsFromDate(DateTime.now());

      await agendaDao.insertEvents(events);

      await sharedPreferences.setInt(
        PrefsConstants.lastUpdateAgenda,
        DateTime.now().millisecondsSinceEpoch,
      );
    } else {
      throw NotConntectedException();
    }
  }

  @override
  Future updateAllAgenda() async {
    if (await networkInfo.isConnected) {
      final profile = await profileDao.getProfile();

      final interval = DateUtils.getDateInerval();
      final agenda = await spaggiariClient.getAgenda(
          profile.studentId, interval.begin, interval.end);
      List<AgendaEvent> events = [];
      Color color;

      agenda.events.forEach((event) {
        if (GlobalUtils.isVerificaOrInterrogazione(event.notes)) {
          color = Colors.red;
        } else {
          color = Colors.green;
        }
        events.add(EventMapper.convertEventEntityToInsertable(event, color));
      });

      await agendaDao.deleteAllEventsWithoutLocal();

      await agendaDao.insertEvents(events);

      await sharedPreferences.setInt(
        PrefsConstants.lastUpdateAgenda,
        DateTime.now().millisecondsSinceEpoch,
      );
    } else {
      throw NotConntectedException();
    }
  }

  @override
  Future insertEvent(AgendaEvent event) async {
    return agendaDao.insertEvent(event);
  }

  @override
  Future deleteAllEvents() {
    return agendaDao.deleteAllEvents();
  }

  @override
  Future<List<AgendaEvent>> getAllEvents() {
    return agendaDao.getAllEvents();
  }

  @override
  Future<List<AgendaEvent>> getLastEvents(
    DateTime date, {
    int numbersOfEvents,
  }) {
    return agendaDao.getLastEvents(
      date,
      numbersOfEvents: numbersOfEvents,
    );
  }

  @override
  Future deleteEvent(AgendaEvent event) async {
    return agendaDao.deleteEvent(event);
  }

  @override
  Future insertLocalEvent(AgendaEvent event) async {
    return agendaDao.insertEvent(event);
  }

  @override
  Future updateEvent(AgendaEvent event) async {
    return agendaDao.updateEvent(event);
  }
}
