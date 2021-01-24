import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:registro_elettronico/core/data/model/event_type.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/core/presentation/widgets/unicorn_dialer.dart';
import 'package:registro_elettronico/feature/agenda/domain/model/agenda_data_domain_model.dart';
import 'package:registro_elettronico/feature/agenda/domain/repository/agenda_repository.dart';
import 'package:registro_elettronico/feature/agenda/presentation/loaded/events_list.dart';
import 'package:registro_elettronico/feature/agenda/presentation/updater/agenda_updater_bloc.dart';
import 'package:registro_elettronico/utils/global_utils.dart';
import 'package:table_calendar/table_calendar.dart';

import 'event/new_event_page.dart';
import 'lesson_list.dart';

class AgendaLoaded extends StatefulWidget {
  final AgendaDataDomainModel data;

  const AgendaLoaded({
    Key key,
    @required this.data,
  }) : super(key: key);

  @override
  _AgendaLoadedState createState() => _AgendaLoadedState();
}

class _AgendaLoadedState extends State<AgendaLoaded> {
  final CalendarController _calendarController = CalendarController();

  final DateTime _initialDay = DateTime.now();

  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('agenda')),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              final AgendaRepository agendaRepository = sl();
              agendaRepository.updateAllAgenda(ifNeeded: false);
            },
          )
        ],
      ),
      floatingActionButton: _MultiActionsButton(
        dateTime: _selectedDay,
      ),
      body: BlocListener<AgendaUpdaterBloc, AgendaUpdaterState>(
        listener: (context, state) {
          _reactToListenerState(state);
        },
        child: RefreshIndicator(
          onRefresh: () {
            final AgendaRepository agendaRepository = sl();
            return agendaRepository.updateAllAgenda(ifNeeded: false);
          },
          child: ListView(
            children: [
              TableCalendar(
                calendarController: _calendarController,
                events: widget.data.eventsMap,
                initialSelectedDay: _initialDay,
                onDaySelected: _onDaySelected,
                startingDayOfWeek: StartingDayOfWeek.monday,
                locale: AppLocalizations.of(context).locale.toString(),
                weekendDays: const [DateTime.sunday],
                calendarStyle: CalendarStyle(
                  selectedColor: Theme.of(context).accentColor.withOpacity(0.7),
                  todayColor: Theme.of(context).accentColor.withAlpha(140),
                  markersColor: Colors.red[700],
                  outsideDaysVisible: false,
                  outsideStyle: TextStyle(color: Colors.grey[300]),
                  outsideWeekendStyle: TextStyle(
                    color: Theme.of(context).accentColor.withOpacity(0.7),
                  ),
                  weekendStyle: TextStyle(color: Theme.of(context).accentColor),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekendStyle: TextStyle(color: Theme.of(context).accentColor),
                ),
                headerStyle: HeaderStyle(
                  formatButtonTextStyle: const TextStyle()
                      .copyWith(color: Colors.white, fontSize: 15.0),
                  formatButtonDecoration: BoxDecoration(
                    color: Colors.deepOrange[400],
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  formatButtonVisible: false,
                ),
                // onDaySelected: _onDaySelected,
                builders: CalendarBuilders(
                  singleMarkerBuilder: (context, date, event) {
                    Color cor = _getLabelColor(event.labelColor);
                    return Container(
                      decoration:
                          BoxDecoration(shape: BoxShape.circle, color: cor),
                      width: 7.0,
                      height: 7.0,
                      margin: const EdgeInsets.symmetric(horizontal: 1.5),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              AgendaEventsList(
                events: widget.data.eventsMapString[_convertDate(_selectedDay)],
              ),
              LessonsList(
                lessons: widget.data.lessonsMap[_convertDate(_selectedDay)],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _convertDate(DateTime date) {
    final formatter = DateFormat('yyyyMMdd');
    return formatter.format(date);
  }

  Color _getLabelColor(String eventColor) {
    return Color(int.tryParse(eventColor) ?? Colors.red.value);
  }

  void _onDaySelected(DateTime day, List events, List events2) {
    print(day);
    print("Event" + widget.data.eventsMap.keys.first.toString());

    setState(() {
      _selectedDay = day;
    });
  }

  void _reactToListenerState(AgendaUpdaterState state) {}
}

class _MultiActionsButton extends StatelessWidget {
  final DateTime dateTime;

  const _MultiActionsButton({
    Key key,
    @required this.dateTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnicornDialer(
      parentButtonBackground: Theme.of(context).accentColor,
      orientation: UnicornOrientation.VERTICAL,
      parentButton: Icon(Icons.add),
      hasBackground: false,
      childButtons: [
        UnicornButton(
          hasLabel: true,
          labelFontSize: 12,
          labelText: AppLocalizations.of(context).translate('memo'),
          labelHasShadow: false,
          labelColor:
              GlobalUtils.isDark(context) ? Colors.grey[800] : Colors.white,
          labelBackgroundColor:
              GlobalUtils.isDark(context) ? Colors.white : Colors.grey[800],
          currentButton: FloatingActionButton(
            heroTag: "memo_fab",
            backgroundColor: Colors.white,
            mini: true,
            child: Icon(
              Icons.notifications,
              color: Colors.grey[700],
              size: 17,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NewEventPage(
                    eventType: EventType.memo,
                    initialDate: dateTime ?? DateTime.now(),
                  ),
                ),
              );
            },
          ),
        ),
        UnicornButton(
          hasLabel: true,
          labelFontSize: 12,
          labelText: AppLocalizations.of(context).translate('test'),
          labelHasShadow: false,
          labelColor:
              GlobalUtils.isDark(context) ? Colors.grey[800] : Colors.white,
          labelBackgroundColor:
              GlobalUtils.isDark(context) ? Colors.white : Colors.grey[800],
          currentButton: FloatingActionButton(
            heroTag: "test_fab",
            backgroundColor: Colors.white,
            mini: true,
            child: Icon(
              Icons.assignment,
              color: Colors.grey[700],
              size: 17,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NewEventPage(
                    eventType: EventType.test,
                    initialDate: dateTime ?? DateTime.now(),
                  ),
                ),
              );
            },
          ),
        ),
        UnicornButton(
          hasLabel: true,
          labelFontSize: 12,
          labelText: AppLocalizations.of(context).translate('homework'),
          labelHasShadow: false,
          labelColor:
              GlobalUtils.isDark(context) ? Colors.grey[800] : Colors.white,
          labelBackgroundColor:
              GlobalUtils.isDark(context) ? Colors.white : Colors.grey[800],
          currentButton: FloatingActionButton(
            heroTag: "assignment_fab",
            backgroundColor: Colors.white,
            mini: true,
            child: Icon(
              Icons.import_contacts,
              color: Colors.grey[700],
              size: 17,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NewEventPage(
                    eventType: EventType.assigment,
                    initialDate: dateTime ?? DateTime.now(),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
