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
  EventMapper eventMapper;
  ProfileDao profileDao;

  AgendaRepositoryImpl(
      this.spaggiariClient, this.agendaDao, this.eventMapper, this.profileDao);

  @override
  Future updateAgendaBetweenDates(DateTime begin, DateTime end) async {
    final profile = await profileDao.getProfile();

    final beginDate = DateUtils.convertDate(begin);
    final endDate = DateUtils.convertDate(end);

    final agenda =
        await spaggiariClient.getAgenda(profile.studentId, beginDate, endDate);
    agenda.events.forEach((event) {
      agendaDao.insertEvent(eventMapper.convertEventEntityToInsertable(event));
    });
  }

  @override
  Future updateAgendaStartingFromDate(DateTime begin) async {
    final profile = await profileDao.getProfile();

    final now = DateUtils.convertDate(DateTime.now());
    final interval = DateUtils.getDateInerval();
    final agenda =
        await spaggiariClient.getAgenda(profile.studentId, now, interval.end);
    agenda.events.forEach((event) {
      agendaDao.insertEvent(eventMapper.convertEventEntityToInsertable(event));
    });
  }

  @override
  Future updateAllAgenda() async {
    final profile = await profileDao.getProfile();

    final interval = DateUtils.getDateInerval();
    final agenda = await spaggiariClient.getAgenda(
        profile.studentId, interval.begin, interval.end);
    agenda.events.forEach((event) {
      agendaDao.insertEvent(eventMapper.convertEventEntityToInsertable(event));
    });
  }

  @override
  Future insertEvent(AgendaEvent event) {
    return agendaDao.insertEvent(event);
  }

  @override
  Stream<List<AgendaEvent>> watchAllEvents() {
    return agendaDao.watchAllEvents();
  }

  @override
  Stream<List<AgendaEvent>> watchLastEvents(
      DateTime date, int numbersOfEvents) {
    return agendaDao.watchLastEvents(date, numbersOfEvents);
  }

  @override
  Future deleteAllEvents() {
    return agendaDao.deleteAllEvents();
  }
}
