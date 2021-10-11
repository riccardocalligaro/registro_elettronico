import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:intl/intl.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/core/presentation/custom/states/sr_search_empty_view.dart';
import 'package:registro_elettronico/feature/agenda/domain/model/agenda_data_domain_model.dart';
import 'package:registro_elettronico/feature/agenda/domain/model/agenda_event_domain_model.dart';
import 'package:registro_elettronico/feature/agenda/presentation/loaded/events_list.dart';
import 'package:registro_elettronico/feature/agenda/presentation/updater/agenda_updater_bloc.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:registro_elettronico/utils/update_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  late SearchBar _searchBar;
  String _searchQuery = '';

  @override
  void initState() {
    SharedPreferences sharedPreferences = sl();
    final savedFormat =
        sharedPreferences.getInt(PrefsConstants.preferredCalendarFormat);

    setState(() {
      _calendarFormat = CalendarFormat.values[savedFormat ?? 0];
    });
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
                    TableCalendar(
                      calendarFormat: _calendarFormat,
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      weekendDays: const [DateTime.sunday],
                      onDaySelected: (selectedDay, focusedDay) =>
                          _onDaySelected(selectedDay),
                      eventLoader: (date) => _getEventsForDay(date),
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },
                      firstDay: DateTime.now().subtract(Duration(days: 365)),
                      lastDay: DateTime.now().add(Duration(days: 365)),
                      calendarBuilders: CalendarBuilders(
                        singleMarkerBuilder:
                            (context, date, AgendaEventDomainModel event) {
                          Color cor = _getLabelColor(event.labelColor ?? '');
                          return Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: cor),
                            width: 7.0,
                            height: 7.0,
                            margin: const EdgeInsets.symmetric(horizontal: 1.5),
                          );
                        },
                      ),
                      calendarStyle: CalendarStyle(
                        // Ugly, I know, but this is needed if you want to set
                        // the borderRadius of the decoration
                        weekendDecoration:
                            BoxDecoration(shape: BoxShape.rectangle),
                        rangeEndDecoration:
                            BoxDecoration(shape: BoxShape.rectangle),
                        defaultDecoration:
                            BoxDecoration(shape: BoxShape.rectangle),
                        rowDecoration: BoxDecoration(shape: BoxShape.rectangle),
                        markerDecoration:
                            BoxDecoration(shape: BoxShape.rectangle),
                        holidayDecoration:
                            BoxDecoration(shape: BoxShape.rectangle),
                        outsideDecoration:
                            BoxDecoration(shape: BoxShape.rectangle),
                        disabledDecoration:
                            BoxDecoration(shape: BoxShape.rectangle),
                        rangeStartDecoration:
                            BoxDecoration(shape: BoxShape.rectangle),
                        withinRangeDecoration:
                            BoxDecoration(shape: BoxShape.rectangle),
                        selectedDecoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.7),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        todayDecoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        outsideDaysVisible: false,
                        outsideTextStyle: TextStyle(color: Colors.grey[300]),
                        weekendTextStyle: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      daysOfWeekStyle: DaysOfWeekStyle(
                        weekendStyle: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      headerStyle: HeaderStyle(
                        formatButtonTextStyle: const TextStyle()
                            .copyWith(color: Colors.white, fontSize: 15.0),
                        formatButtonDecoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        formatButtonVisible: true,
                      ),
                      onFormatChanged: (format) {
                        setState(() {
                          _calendarFormat = format;
                        });

                        SharedPreferences sharedPreferences = sl();
                        sharedPreferences.setInt(
                          PrefsConstants.preferredCalendarFormat,
                          format.index,
                        );
                      },
                    ),
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

  List<AgendaEventDomainModel> _getEventsForDay(DateTime day) {
    return widget.data!.eventsMap[day] ?? [];
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
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

  void _onDaySelected(DateTime day) {
    setState(() {
      _selectedDay = day;
      _focusedDay = day;
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

class _MultiActionsButton extends StatefulWidget {
  final DateTime? dateTime;

  const _MultiActionsButton({
    Key? key,
    this.dateTime,
  }) : super(key: key);

  @override
  State<_MultiActionsButton> createState() => _MultiActionsButtonState();
}

class _MultiActionsButtonState extends State<_MultiActionsButton> {
  var isDialOpen = ValueNotifier<bool>(false);
  var extend = false;
  var visible = true;

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      // animatedIcon: AnimatedIcons.menu_close,
      // animatedIconTheme: IconThemeData(size: 22.0),
      // / This is ignored if animatedIcon is non null
      // child: Text("open"),
      // activeChild: Text("close"),
      icon: Icons.add,
      iconTheme: IconThemeData(color: Colors.white),
      activeIcon: Icons.close,
      spacing: 3,
      openCloseDial: isDialOpen,
      childPadding: const EdgeInsets.all(5),
      spaceBetweenChildren: 4,

      buttonSize: 56, // it's the SpeedDial size which defaults to 56 itself
      // iconTheme: IconThemeData(size: 22),
      label:
          extend ? const Text("Open") : null, // The label of the main button.
      /// The active label of the main button, Defaults to label if not specified.
      activeLabel: extend ? const Text("Close") : null,

      /// Transition Builder between label and activeLabel, defaults to FadeTransition.
      // labelTransitionBuilder: (widget, animation) => ScaleTransition(scale: animation,child: widget),
      /// The below button size defaults to 56 itself, its the SpeedDial childrens size
      childrenButtonSize: 56.0,
      visible: visible,

      // overlayColor: Colors.black,
      // overlayOpacity: 0.5,
      onOpen: () => debugPrint('OPENING DIAL'),
      onClose: () => debugPrint('DIAL CLOSED'),
      tooltip: 'Open Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      // foregroundColor: Colors.black,
      // backgroundColor: Colors.white,
      // activeForegroundColor: Colors.red,
      // activeBackgroundColor: Colors.blue,
      elevation: 10.0,
      isOpenOnStart: false,
      animationSpeed: 200,

      children: [
        SpeedDialChild(
          child: const Icon(Icons.notifications),
          backgroundColor: Colors.green[700],
          foregroundColor: Colors.white,
          label: 'Memo',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NewEventPage(
                  eventType: AgendaEventType.memo,
                  initialDate: widget.dateTime ?? DateTime.now(),
                ),
              ),
            );
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.assignment),
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,
          label: AppLocalizations.of(context)!.translate('test'),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NewEventPage(
                  eventType: AgendaEventType.test,
                  initialDate: widget.dateTime ?? DateTime.now(),
                ),
              ),
            );
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.import_contacts),
          backgroundColor: Colors.blue[700],
          foregroundColor: Colors.white,
          label: AppLocalizations.of(context)!.translate('homework'),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NewEventPage(
                  eventType: AgendaEventType.assigment,
                  initialDate: widget.dateTime ?? DateTime.now(),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
