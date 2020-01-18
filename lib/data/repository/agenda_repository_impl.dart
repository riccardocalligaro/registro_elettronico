import 'package:f_logs/f_logs.dart';
import 'package:registro_elettronico/data/db/dao/agenda_dao.dart';
import 'package:registro_elettronico/data/db/dao/profile_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/network/service/api/spaggiari_client.dart';
import 'package:registro_elettronico/data/repository/mapper/event_mapper.dart';
import 'package:registro_elettronico/domain/repository/agenda_repository.dart';
import 'package:registro_elettronico/utils/date_utils.dart';

class AgendaRepositoryImpl implements AgendaRepository {
  SpaggiariClient spaggiariClient;
  AgendaDao agendaDao;
  ProfileDao profileDao;

  AgendaRepositoryImpl(this.spaggiariClient, this.agendaDao, this.profileDao);

  @override
  Future updateAgendaBetweenDates(DateTime begin, DateTime end) async {
    final profile = await profileDao.getProfile();

    final beginDate = DateUtils.convertDate(begin);
    final endDate = DateUtils.convertDate(end);
    List<AgendaEvent> events = [];

    final agenda =
        await spaggiariClient.getAgenda(profile.studentId, beginDate, endDate);

    await agendaDao.deleteAllEvents();
    agenda.events.forEach((event) {
      events.add(EventMapper.convertEventEntityToInsertable(event));
    });

    FLog.info(
      text:
          'Got ${agenda.events.length} events from server, procceding to insert in database',
    );
    agendaDao.insertEvents(events);
  }

  @override
  Future updateAgendaStartingFromDate(DateTime begin) async {
    final profile = await profileDao.getProfile();

    final now = DateUtils.convertDate(DateTime.now());
    final interval = DateUtils.getDateInerval();
    final agenda =
        await spaggiariClient.getAgenda(profile.studentId, now, interval.end);
    List<AgendaEvent> events = [];

    agenda.events.forEach((event) {
      events.add(EventMapper.convertEventEntityToInsertable(event));
    });
    agendaDao.insertEvents(events);
  }

  @override
  Future updateAllAgenda() async {
    final profile = await profileDao.getProfile();

    final interval = DateUtils.getDateInerval();
    final agenda = await spaggiariClient.getAgenda(
        profile.studentId, interval.begin, interval.end);
    List<AgendaEvent> events = [];
    agenda.events.forEach((event) {
      events.add(EventMapper.convertEventEntityToInsertable(event));
    });
    agendaDao.insertEvents(events);
  }

  @override
  Future insertEvent(AgendaEvent event) {
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
  Future<List<AgendaEvent>> getLastEvents(DateTime date, int numbersOfEvents) {
    return agendaDao.getLastEvents(date, numbersOfEvents);
  }
}
