import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injector/injector.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:registro_elettronico/component/navigator.dart';
import 'package:registro_elettronico/data/db/moor_database.dart' as db;
import 'package:registro_elettronico/domain/entity/event_type.dart';
import 'package:registro_elettronico/domain/repository/agenda_repository.dart';
import 'package:registro_elettronico/ui/bloc/agenda/agenda_bloc.dart';
import 'package:registro_elettronico/ui/bloc/agenda/bloc.dart';
import 'package:registro_elettronico/ui/bloc/lessons/bloc.dart';
import 'package:registro_elettronico/ui/bloc/lessons/lessons_bloc.dart';
import 'package:registro_elettronico/ui/feature/agenda/views/edit_event_page.dart';
import 'package:registro_elettronico/ui/feature/agenda/views/new_event_page.dart';
import 'package:registro_elettronico/ui/feature/widgets/cusotm_placeholder.dart';
import 'package:registro_elettronico/ui/feature/widgets/custom_refresher.dart';
import 'package:registro_elettronico/ui/feature/widgets/last_update_bottom_sheet.dart';
import 'package:registro_elettronico/ui/feature/widgets/unicorn_dialer.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:registro_elettronico/utils/global_utils.dart';
import 'package:registro_elettronico/utils/string_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class AgendaPage extends StatefulWidget {
  AgendaPage({Key key}) : super(key: key);

  @override
  _AgendaPageState createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> with TickerProviderStateMixin {
  // GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  RefreshController _refreshController = RefreshController();

  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;
  int _agendaLastUpdate;
  DateTime _selectedDay = DateTime.now();
  DateTime _initialDay = DateTime.now();

  @override
  void initState() {
    restore();
    super.initState();

    // Things necessary for the table calendar
    _selectedEvents = [];
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();

    BlocProvider.of<LessonsBloc>(context)
        .add(GetLessonsByDate(dateTime: DateTime.now()));

    BlocProvider.of<AgendaBloc>(context).add(GetAllAgenda());
  }

  void restore() async {
    SharedPreferences sharedPreferences = Injector.appInstance.getDependency();
    setState(() {
      _agendaLastUpdate =
          sharedPreferences.getInt(PrefsConstants.LAST_UPDATE_AGENDA);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    _selectedDay = day;

    // We need to update the bloc for the lessons of that day
    BlocProvider.of<LessonsBloc>(context).add(GetLessonsByDate(dateTime: day));

    setState(() {
      events.sort((a, b) => a.begin.compareTo(b.begin));
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
    DateTime first,
    DateTime last,
    CalendarFormat format,
  ) {}

  @override
  Widget build(BuildContext context) {
    var childButtons = List<UnicornButton>();

    childButtons.add(
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
            Navigator.of(context)
                .push(
              MaterialPageRoute(
                builder: (context) => NewEventPage(
                  eventType: EventType.memo,
                  initialDate: _selectedDay ?? DateTime.now(),
                ),
              ),
            )
                .then((date) {
              if (date != null) {
                BlocProvider.of<AgendaBloc>(context).add(GetAllAgenda());

                setState(() {
                  _initialDay = date;
                  _calendarController.setSelectedDay(date, runCallback: true);
                });
              }
            });
          },
        ),
      ),
    );

    childButtons.add(
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
            Navigator.of(context)
                .push(
              MaterialPageRoute(
                builder: (context) => NewEventPage(
                  eventType: EventType.test,
                  initialDate: _selectedDay ?? DateTime.now(),
                ),
              ),
            )
                .then((date) {
              if (date != null) {
                BlocProvider.of<AgendaBloc>(context).add(GetAllAgenda());

                setState(() {
                  _initialDay = date;
                  _calendarController.setSelectedDay(date, runCallback: true);
                });
              }
            });
          },
        ),
      ),
    );
    childButtons.add(
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
            Navigator.of(context)
                .push(
              MaterialPageRoute(
                builder: (context) => NewEventPage(
                  eventType: EventType.assigment,
                  initialDate: _selectedDay ?? DateTime.now(),
                ),
              ),
            )
                .then((date) {
              if (date != null) {
                BlocProvider.of<AgendaBloc>(context).add(GetAllAgenda());

                setState(() {
                  _initialDay = date;
                  _calendarController.setSelectedDay(date, runCallback: true);
                });
              }
            });
            // Go to dialog
          },
        ),
      ),
    );

    return Scaffold(
      //key: _drawerKey,
      appBar: AppBar(
        //scaffoldKey: _drawerKey,
        title: Text(AppLocalizations.of(context).translate('agenda')),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshAgenda,
          )
        ],
      ),
      // drawer: AppDrawer(
      //   position: DrawerConstants.AGENDA,
      // ),
      floatingActionButton: UnicornDialer(
        parentButtonBackground: Colors.redAccent,
        orientation: UnicornOrientation.VERTICAL,
        parentButton: Icon(Icons.add),
        childButtons: childButtons,
        hasBackground: false,
      ),
      bottomSheet: LastUpdateBottomSheet(
        millisecondsSinceEpoch: _agendaLastUpdate,
      ),
      body: BlocListener<AgendaBloc, AgendaState>(
        listener: (context, state) {
          if (state is AgendaUpdateLoadSuccess) {
            _refreshController.refreshCompleted();

            setState(() {
              _agendaLastUpdate = DateTime.now().millisecondsSinceEpoch;
            });
          } else if (state is AgendaLoadSuccess) {
            setState(() {
              _selectedEvents = state.events
                  .where((d) => DateUtils.areSameDay(d.begin, _selectedDay))
                  .toList();
            });
          } else if (state is AgendaLoadErrorNotConnected) {
            Scaffold.of(context).showSnackBar(
                AppNavigator.instance.getNetworkErrorSnackBar(context));
          }
        },
        child: CustomRefresher(
          controller: _refreshController,
          onRefresh: _refreshAgenda,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildAgendaBlocBuilder(),
                const SizedBox(height: 8.0),
                const SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 8.0),
                  child: Text(
                    AppLocalizations.of(context).translate('events'),
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  child: _buildEventsMap(),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 0.0),
                  child: Text(
                    AppLocalizations.of(context).translate('lessons'),
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                SingleChildScrollView(
                  child: _buildLessonsBlocBuilder(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAgendaBlocBuilder() {
    return BlocBuilder<AgendaBloc, AgendaState>(
      builder: (context, state) {
        if (state is AgendaUpdateLoadInProgress) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 140),
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is AgendaLoadSuccess) {
          return _buildTableCalendar(state.events);
        } else if (state is AgendaLoadError) {
          return CustomPlaceHolder(
            text: AppLocalizations.of(context).translate('error'),
            icon: Icons.error,
            showUpdate: true,
            onTap: () {
              BlocProvider.of<AgendaBloc>(context).add(UpdateAllAgenda());
            },
          );
        }

        return Container();
      },
    );
  }

  Widget _buildTableCalendar(List<db.AgendaEvent> events) {
    final Map<DateTime, List<db.AgendaEvent>> eventsMap = Map.fromIterable(
      events,
      key: (e) => e.begin,
      value: (e) => events
          .where((event) => DateUtils.areSameDay(event.begin, e.begin))
          .toList(),
    );

    return TableCalendar(
      calendarController: _calendarController,
      events: eventsMap,
      initialSelectedDay: _initialDay,
      startingDayOfWeek: StartingDayOfWeek.monday,
      locale: AppLocalizations.of(context).locale.toString(),
      weekendDays: const [DateTime.sunday],
      calendarStyle: CalendarStyle(
        selectedColor: Colors.red[400],
        todayColor: Colors.red[200],
        markersColor: Colors.red[700],
        outsideDaysVisible: false,
        outsideStyle: TextStyle(color: Colors.grey[300]),
        outsideWeekendStyle: TextStyle(color: Colors.red[100]),
        weekendStyle: TextStyle(color: Colors.red),
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle:
            TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.deepOrange[400],
          borderRadius: BorderRadius.circular(16.0),
        ),
        formatButtonVisible: false,
      ),
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
      builders: CalendarBuilders(
        singleMarkerBuilder: (context, date, event) {
          Color cor = Color(int.parse(event.labelColor));
          return Container(
            decoration: BoxDecoration(shape: BoxShape.circle, color: cor),
            width: 7.0,
            height: 7.0,
            margin: const EdgeInsets.symmetric(horizontal: 1.5),
          );
        },
      ),
    );
  }

  List<Widget> markersBuilder(context, date, events, holidays) {
    final children = <Widget>[];

    if (events.isNotEmpty) {
      children.add(
        Positioned(
          // top: widget.calendarStyle.markersPositionTop,
          // bottom: widget.calendarStyle.markersPositionBottom,
          // left: widget.calendarStyle.markersPositionLeft,
          // right: widget.calendarStyle.markersPositionRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: events
                //.take(widget.calendarStyle.markersMaxAmount)
                .map((event) => _buildMarker())
                .toList(),
          ),
        ),
      );
      // children.add(
      //   Positioned(right: 1, bottom: 1, child: buildEventsMarker(date, events)),
      // );
    }
    // if (holidays.isNotEmpty) {
    //   children.add(
    //     Positioned(right: 1, bottom: 1, child: _buildMarker(date, events)),
    //   );
    // }
    return children;
  }

  Widget _buildMarker() {
    return Container(
      width: 8.0,
      height: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 0.3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.red,
      ),
    );
  }

  // Widget _buildMarker2(DateTime date, db.AgendaEvent events) {
  //   //final eventevents.where((e)=>e.begin.day == date.day).forEach(f)
  //   return Container(
  //     width: 8.0,
  //     height: 8.0,
  //     margin: const EdgeInsets.symmetric(horizontal: 0.3),
  //     decoration: BoxDecoration(
  //       shape: BoxShape.circle,
  //       color: Colors.red,
  //     ),
  //   );
  //   // return AnimatedContainer(
  //   //   duration: const Duration(milliseconds: 300),
  //   //   decoration: BoxDecoration(
  //   //     shape: BoxShape.rectangle,
  //   //     color: _calendarController.isSelected(date)
  //   //         ? Colors.brown[500]
  //   //         : this._calendarController.isToday(date)
  //   //             ? Colors.brown[300]
  //   //             : Colors.blue[400],
  //   //   ),
  //   //   width: 16.0,
  //   //   height: 16.0,
  //   //   child: Center(
  //   //     child: Text(
  //   //       '${events.length}',
  //   //       style: TextStyle().copyWith(
  //   //         color: Colors.white,
  //   //         fontSize: 12.0,
  //   //       ),
  //   //     ),
  //   //   ),
  //   // );
  // }

  Widget _buildLessonsBlocBuilder() {
    return BlocBuilder<LessonsBloc, LessonsState>(
      builder: (context, state) {
        if (state is LessonsLoadInProgress) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is LessonsLoadSuccess) {
          return _buildLessonsList(state.lessons);
        }
        return Text(state.toString());
      },
    );
  }

  Widget _buildLessonsList(List<db.Lesson> lessons) {
    if (lessons.length == 0) {
      return Padding(
        padding: const EdgeInsets.only(top: 64.0),
        child: CustomPlaceHolder(
          icon: Icons.subject,
          text: '',
          showUpdate: false,
        ),
      );
    }
    return IgnorePointer(
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 24.0),
        shrinkWrap: true,
        itemCount: lessons.length,
        itemBuilder: (ctx, index) {
          final lesson = lessons[index];
          return Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 6.0, 16.0, 0.0),
            child: Card(
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                  child: Text(
                    StringUtils.titleCase(lesson.author),
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                  child: Text(
                    lesson.lessonArg != ""
                        ? lesson.lessonArg
                        : lesson.lessonType,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEventsMap() {
    if (_selectedEvents.length > 0) {
      return ListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: _selectedEvents.map((e) {
            final db.AgendaEvent event = e;

            if (event.isLocal) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 6.0),
                child: Card(
                  color: Color(int.parse(event.labelColor)),
                  child: ListTile(
                    onTap: () async {
                      await _showBottomSheet(event);
                    },
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context)
                              .translate('hour')
                              .toLowerCase(),
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          DateUtils.convertTimeForDisplay(event.begin,
                              AppLocalizations.of(context).locale.toString()),
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                    title: Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                      child: Text(
                        '${event.title.trim()} - ${event.subjectDesc.toLowerCase()}',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                    subtitle: event.notes != ''
                        ? Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                            child: Text(
                              '${event.notes} ${event.isFullDay ? " - (Tutto il giorno)" : ""}',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : null,
                  ),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 6.0),
                child: Card(
                  color: Colors.red[400],
                  child: ListTile(
                    onTap: () async {
                      await _showLocalBoottomSheet(event);
                    },
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context)
                              .translate('hour')
                              .toLowerCase(),
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          '${event.begin.hour.toString()} - ${event.end.hour.toString()}',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                    title: Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                      child: Text(
                        '${event.authorName.length > 0 ? StringUtils.titleCase(event.authorName) : 'No name'}',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                      child: Text(
                        '${event.notes} ${event.isFullDay ? " - (Tutto il giorno)" : ""}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              );
            }
          }).toList());
    }

    return Padding(
      padding: const EdgeInsets.only(top: 64.0),
      child: CustomPlaceHolder(
        icon: Icons.event,
        text: '',
        showUpdate: false,
      ),
    );
  }

  Future _showLocalBoottomSheet(db.AgendaEvent event) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              onTap: () {
                final trans = AppLocalizations.of(context);

                String message = "";
                message +=
                    '${trans.translate('event')}: ${event.title != '' ? event.title : event.notes}';

                if (event.notes != '') {
                  message += '\n';
                  message += trans
                      .translate('notes_event')
                      .replaceAll('{name}', event.notes);
                }

                if (event.begin != null) {
                  message += '\n';

                  message += trans.translate('date_event').replaceAll(
                        '{date}',
                        DateUtils.convertDateLocaleDashboard(
                          event.begin,
                          AppLocalizations.of(context).locale.toString(),
                        ),
                      );
                }

                if (event.subjectId != -1) {
                  message += '\n';

                  message += trans.translate('subject_event').replaceAll(
                      '{subject}', StringUtils.titleCase(event.subjectDesc));
                }
                Navigator.pop(context);

                Share.text('Condividi', message, 'text/plain');
              },
              leading: Icon(Icons.share),
              title: Text(AppLocalizations.of(context).translate('share')),
            )
          ],
        );
      },
    );
  }

  Future _showBottomSheet(db.AgendaEvent event) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.delete),
              title: Text(AppLocalizations.of(context).translate('delete')),
              onTap: () async {
                await RepositoryProvider.of<AgendaRepository>(context)
                    .deleteEvent(event);

                BlocProvider.of<AgendaBloc>(context).add(GetAllAgenda());

                setState(() {
                  _initialDay = event.begin;
                  _calendarController.setSelectedDay(event.begin,
                      runCallback: true);
                });

                FlutterLocalNotificationsPlugin
                    flutterLocalNotificationsPlugin =
                    FlutterLocalNotificationsPlugin();

                await flutterLocalNotificationsPlugin.cancel(event.evtId);

                Navigator.pop(context);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                  builder: (context) => EditEventPage(
                    event: event,
                    type: event.subjectId != -1
                        ? EventType.assigment
                        : EventType.memo,
                  ),
                ))
                    .then((date) {
                  BlocProvider.of<AgendaBloc>(context).add(GetAllAgenda());

                  setState(() {
                    _initialDay = event.begin;
                    _calendarController.setSelectedDay(event.begin,
                        runCallback: true);
                  });

                  Navigator.pop(context);
                });
              },
              leading: Icon(Icons.edit),
              title: Text(AppLocalizations.of(context).translate('modify')),
            ),
            ListTile(
              onTap: () {
                final trans = AppLocalizations.of(context);

                String message = "";
                message +=
                    '${trans.translate('event')}: ${event.title != '' ? event.title : event.notes}';

                if (event.notes != '') {
                  message += '\n';
                  message += trans
                      .translate('notes_event')
                      .replaceAll('{name}', event.notes);
                }

                if (event.begin != null) {
                  message += '\n';

                  message += trans.translate('date_event').replaceAll(
                        '{date}',
                        DateUtils.convertDateLocaleDashboard(
                          event.begin,
                          AppLocalizations.of(context).locale.toString(),
                        ),
                      );
                }

                if (event.subjectId != -1) {
                  message += '\n';

                  message += trans.translate('subject_event').replaceAll(
                      '{subject}', StringUtils.titleCase(event.subjectDesc));
                }
                Navigator.pop(context);

                Share.text('Condividi', message, 'text/plain');
              },
              leading: Icon(Icons.share),
              title: Text(AppLocalizations.of(context).translate('share')),
            )
          ],
        );
      },
    );
  }

  Future _refreshAgenda() async {
    BlocProvider.of<AgendaBloc>(context).add(UpdateAllAgenda());
    BlocProvider.of<AgendaBloc>(context).add(GetAllAgenda());
    _refreshController.refreshFailed();
  }
}
