import 'package:fl_chart/fl_chart.dart';
import 'package:registro_elettronico/feature/agenda/domain/model/agenda_event_domain_model.dart';
import 'package:registro_elettronico/feature/lessons/domain/model/lesson_domain_model.dart';

enum AgendaEventType { memo, test, assigment }

class AgendaDataDomainModel {
  Map<DateTime?, List<AgendaEventDomainModel>> eventsMap;
  Map<String, List<LessonDomainModel>> lessonsMap;
  Map<String, List<AgendaEventDomainModel>> eventsMapString;
  List<FlSpot> eventsSpots;

  List<AgendaEventDomainModel> allEvents;
  List<AgendaEventDomainModel> events;
  List<LessonDomainModel> lessons;

  AgendaDataDomainModel({
    required this.events,
    required this.eventsMap,
    required this.lessonsMap,
    required this.eventsMapString,
    required this.eventsSpots,
    required this.lessons,
    required this.allEvents,
  });
}
