import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/core/presentation/custom/sr_search_empty_view.dart';
import 'package:registro_elettronico/feature/agenda/domain/model/agenda_data_domain_model.dart';
import 'package:registro_elettronico/feature/agenda/domain/model/agenda_event_domain_model.dart';
import 'package:registro_elettronico/feature/agenda/presentation/loaded/events_list.dart';
import 'package:registro_elettronico/feature/agenda/presentation/updater/agenda_updater_bloc.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:registro_elettronico/utils/global_utils.dart';
import 'package:registro_elettronico/utils/update_manager.dart';
import 'package:table_calendar/table_calendar.dart';

import 'event/new_event_page.dart';
import 'lesson_list.dart';

class AgendaLoaded extends StatefulWidget {
  final AgendaDataDomainModel? data;

  const AgendaLoaded({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  _AgendaLoadedState createState() => _AgendaLoadedState();
}

class _AgendaLoadedState extends State<AgendaLoaded> {
  //final CalendarController _calendarController = CalendarController();

  final DateTime _initialDay = DateTime.now();

  DateTime _selectedDay = DateTime.now();

  late SearchBar _searchBar;
  String _searchQuery = '';

  @override
  void initState() {
    _searchBar = SearchBar(
      setState: setState,
      onChanged: (query) {
        if (query.isNotEmpty) {
          setState(() => _searchQuery = query);
        }
      },
      onClosed: () {
        setState(() => _searchQuery = '');
      },
      onCleared: () {
        setState(() => _searchQuery = '');
      },
      buildDefaultAppBar: buildAppBar,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _searchBar.build(context),
      floatingActionButton: _MultiActionsButton(
        dateTime: _selectedDay,
      ),
      body: BlocListener<AgendaUpdaterBloc, AgendaUpdaterState>(
        listener: (context, state) {
          _reactToListenerState(state);
        },
        child: RefreshIndicator(
          onRefresh: () {
            final SRUpdateManager srUpdateManager = sl();
            return srUpdateManager.updateAgendaData(context);
          },
          child: _searchQuery.isNotEmpty && _searchQuery.length >= 2
              ? _AgendaResultsList(
                  query: _searchQuery,
                  events: widget.data!.allEvents,
                )
              : ListView(
                  children: [
                    // TODO: update table calendar
                    // TableCalendar(
                    //   calendarController: _calendarController,
                    //   events: widget.data.eventsMap,
                    //   initialSelectedDay: _initialDay,
                    //   onDaySelected: _onDaySelected,
                    //   startingDayOfWeek: StartingDayOfWeek.monday,
                    //   locale: AppLocalizations.of(context).locale.toString(),
                    //   weekendDays: const [DateTime.sunday],
                    //   calendarStyle: CalendarStyle(
                    //     selectedColor:
                    //         Theme.of(context).accentColor.withOpacity(0.7),
                    //     todayColor:
                    //         Theme.of(context).accentColor.withAlpha(140),
                    //     markersColor: Colors.red[700],
                    //     outsideDaysVisible: false,
                    //     outsideStyle: TextStyle(color: Colors.grey[300]),
                    //     outsideWeekendStyle: TextStyle(
                    //       color: Theme.of(context).accentColor.withOpacity(0.7),
                    //     ),
                    //     weekendStyle:
                    //         TextStyle(color: Theme.of(context).accentColor),
                    //   ),
                    //   daysOfWeekStyle: DaysOfWeekStyle(
                    //     weekendStyle:
                    //         TextStyle(color: Theme.of(context).accentColor),
                    //   ),
                    //   headerStyle: HeaderStyle(
                    //     formatButtonTextStyle: const TextStyle()
                    //         .copyWith(color: Colors.white, fontSize: 15.0),
                    //     formatButtonDecoration: BoxDecoration(
                    //       color: Colors.deepOrange[400],
                    //       borderRadius: BorderRadius.circular(16.0),
                    //     ),
                    //     formatButtonVisible: false,
                    //   ),
                    //   // onDaySelected: _onDaySelected,
                    //   builders: CalendarBuilders(
                    //     singleMarkerBuilder: (context, date, event) {
                    //       Color cor = _getLabelColor(event.labelColor);
                    //       return Container(
                    //         decoration: BoxDecoration(
                    //             shape: BoxShape.circle, color: cor),
                    //         width: 7.0,
                    //         height: 7.0,
                    //         margin: const EdgeInsets.symmetric(horizontal: 1.5),
                    //       );
                    //     },
                    //   ),
                    // ),
                    const SizedBox(
                      height: 16,
                    ),
                    AgendaEventsList(
                      events: widget
                          .data!.eventsMapString[_convertDate(_selectedDay)],
                    ),
                    LessonsList(
                      lessons:
                          widget.data!.lessonsMap[_convertDate(_selectedDay)],
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      // TODO: check brightness
      // systemOverlayStyle: Theme.of(context).brightness,
      title: Text(
        AppLocalizations.of(context)!.translate('agenda')!,
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () async {
            final SRUpdateManager srUpdateManager = sl();
            return srUpdateManager.updateAgendaData(context);
          },
        ),
        _searchBar.getSearchAction(context),
      ],
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
    setState(() {
      _selectedDay = day;
    });
  }

  void _reactToListenerState(AgendaUpdaterState state) {}
}

class _AgendaResultsList extends StatelessWidget {
  final String query;
  final List<AgendaEventDomainModel> events;

  const _AgendaResultsList({
    Key? key,
    required this.query,
    required this.events,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final eventsToShow =
        events.where((l) => _showResultEvent(query, l)).toList();

    if (eventsToShow.isEmpty) {
      return SrSearchEmptyView();
    }

    return ListView.builder(
      itemCount: eventsToShow.length,
      padding: const EdgeInsets.all(12.0),
      itemBuilder: (context, index) {
        final event = eventsToShow[index];
        return EventCard(
          event: event,
          additionalTitle:
              '${SRDateUtils.convertDateForDisplay(event.begin)} - ',
        );
      },
    );
  }

  bool _showResultEvent(String query, AgendaEventDomainModel event) {
    final lQuery = query.toLowerCase().replaceAll(' ', '');
    return event.toString().toLowerCase().replaceAll(' ', '').contains(lQuery);
  }
}

class _MultiActionsButton extends StatelessWidget {
  final DateTime dateTime;

  const _MultiActionsButton({
    Key? key,
    required this.dateTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold();
    // return SpeedDial(
    //   parentButtonBackground: Theme.of(context).accentColor,
    //   orientation: UnicornOrientation.VERTICAL,
    //   parentButton: Icon(Icons.add),
    //   hasBackground: false,
    //   children: [
    //     UnicornButton(
    //       hasLabel: true,
    //       labelFontSize: 12,
    //       labelText: AppLocalizations.of(context)!.translate('memo'),
    //       labelHasShadow: false,
    //       labelColor:
    //           GlobalUtils.isDark(context) ? Colors.grey[800] : Colors.white,
    //       labelBackgroundColor:
    //           GlobalUtils.isDark(context) ? Colors.white : Colors.grey[800],
    //       currentButton: FloatingActionButton(
    //         heroTag: "memo_fab",
    //         backgroundColor: Colors.white,
    //         mini: true,
    //         child: Icon(
    //           Icons.notifications,
    //           color: Colors.grey[700],
    //           size: 17,
    //         ),
    //         onPressed: () {
    //           Navigator.of(context).push(
    //             MaterialPageRoute(
    //               builder: (context) => NewEventPage(
    //                 eventType: AgendaEventType.memo,
    //                 initialDate: dateTime ?? DateTime.now(),
    //               ),
    //             ),
    //           );
    //         },
    //       ),
    //     ),
    //     UnicornButton(
    //       hasLabel: true,
    //       labelFontSize: 12,
    //       labelText: AppLocalizations.of(context)!.translate('test'),
    //       labelHasShadow: false,
    //       labelColor:
    //           GlobalUtils.isDark(context) ? Colors.grey[800] : Colors.white,
    //       labelBackgroundColor:
    //           GlobalUtils.isDark(context) ? Colors.white : Colors.grey[800],
    //       currentButton: FloatingActionButton(
    //         heroTag: "test_fab",
    //         backgroundColor: Colors.white,
    //         mini: true,
    //         child: Icon(
    //           Icons.assignment,
    //           color: Colors.grey[700],
    //           size: 17,
    //         ),
    //         onPressed: () {
    //           Navigator.of(context).push(
    //             MaterialPageRoute(
    //               builder: (context) => NewEventPage(
    //                 eventType: AgendaEventType.test,
    //                 initialDate: dateTime ?? DateTime.now(),
    //               ),
    //             ),
    //           );
    //         },
    //       ),
    //     ),
    //     UnicornButton(
    //       hasLabel: true,
    //       labelFontSize: 12,
    //       labelText: AppLocalizations.of(context)!.translate('homework'),
    //       labelHasShadow: false,
    //       labelColor:
    //           GlobalUtils.isDark(context) ? Colors.grey[800] : Colors.white,
    //       labelBackgroundColor:
    //           GlobalUtils.isDark(context) ? Colors.white : Colors.grey[800],
    //       currentButton: FloatingActionButton(
    //         heroTag: "assignment_fab",
    //         backgroundColor: Colors.white,
    //         mini: true,
    //         child: Icon(
    //           Icons.import_contacts,
    //           color: Colors.grey[700],
    //           size: 17,
    //         ),
    //         onPressed: () {
    //           Navigator.of(context).push(
    //             MaterialPageRoute(
    //               builder: (context) => NewEventPage(
    //                 eventType: AgendaEventType.assigment,
    //                 initialDate: dateTime ?? DateTime.now(),
    //               ),
    //             ),
    //           );
    //         },
    //       ),
    //     ),
    //   ],
    // );
  }
}
