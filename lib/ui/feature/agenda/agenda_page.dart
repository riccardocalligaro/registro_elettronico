import 'package:flutter/material.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:table_calendar/table_calendar.dart';

class AgendaPage extends StatefulWidget {
  AgendaPage({Key key}) : super(key: key);

  @override
  _AgendaPageState createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  Map<DateTime, List> _events;
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();

    _events = {
      _selectedDay: ['Event A0', 'Event B0', 'Event C0'],
    };

    _selectedEvents = _events[_selectedDay] ?? [];
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _selectedDay = DateTime.now();
    print(AppLocalizations.of(context).locale.toLanguageTag());
    return TableCalendar(
      rowHeight: 45.0,
      locale: AppLocalizations.of(context).locale.toLanguageTag(),
      calendarController: _calendarController,
      events: _events,
      onDaySelected: _onDaySelected,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        selectedColor: Colors.red[400],
        todayColor: Colors.red[200],
        markersColor: Colors.red[900],
        outsideDaysVisible: true,
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle:
            TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonVisible: false,
      ),
    );
  }
}
