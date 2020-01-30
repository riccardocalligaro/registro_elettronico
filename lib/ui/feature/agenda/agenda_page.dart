import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:registro_elettronico/component/navigator.dart';
import 'package:registro_elettronico/data/db/moor_database.dart' as db;
import 'package:registro_elettronico/ui/bloc/agenda/agenda_bloc.dart';
import 'package:registro_elettronico/ui/bloc/agenda/bloc.dart';
import 'package:registro_elettronico/ui/bloc/lessons/bloc.dart';
import 'package:registro_elettronico/ui/bloc/lessons/lessons_bloc.dart';
import 'package:registro_elettronico/ui/feature/agenda/views/new_test_page.dart';
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
  bool _dialVisible = true;

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
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
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
    // We need to update the bloc for the lessons of that day
    BlocProvider.of<LessonsBloc>(context).add(GetLessonsByDate(dateTime: day));

    setState(() {
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
    final trans = AppLocalizations.of(context);

    childButtons.add(
      UnicornButton(
        hasLabel: true,
        labelFontSize: 12,
        labelText: 'Promemoria',
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
            // Go to dialog
          },
        ),
      ),
    );

    childButtons.add(
      UnicornButton(
        hasLabel: true,
        labelFontSize: 12,
        labelText: 'Verifica',
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
            // Go to dialog
          },
        ),
      ),
    );
    childButtons.add(
      UnicornButton(
        hasLabel: true,
        labelFontSize: 12,
        labelText: 'Compito',
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
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NewTestPage(),
            ));
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
                  .where((d) => DateUtils.areSameDay(d.begin, DateTime.now()))
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
            text: AppLocalizations.of(context).translate('erorr'),
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
      // builders: CalendarBuilders(
      //   markersBuilder: this.markersBuilder,
      // ),
    );
  }

  List<Widget> markersBuilder(context, date, events, holidays) {
    final children = <Widget>[];
    if (events.isNotEmpty) {
      children.add(
        Positioned(right: 1, bottom: 1, child: buildEventsMarker(date, events)),
      );
    }
    if (holidays.isNotEmpty) {
      children.add(
        Positioned(right: 1, bottom: 1, child: buildEventsMarker(date, events)),
      );
    }
    return children;
  }

  Widget buildEventsMarker(DateTime date, List events) {
    //final eventevents.where((e)=>e.begin.day == date.day).forEach(f)
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : this._calendarController.isToday(date)
                ? Colors.brown[300]
                : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

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
      return IgnorePointer(
        child: ListView(
            shrinkWrap: true,
            children: _selectedEvents.map((e) {
              final db.AgendaEvent event = e;
              return Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 6.0),
                child: Card(
                  color: Colors.red[400],
                  child: ListTile(
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(AppLocalizations.of(context)
                            .translate('hour')
                            .toLowerCase()),
                        Text(
                            '${event.begin.hour.toString()} - ${event.end.hour.toString()}')
                      ],
                    ),
                    title: Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                      child: Text(
                        '${StringUtils.titleCase(event.authorName)}',
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
            }).toList()),
      );
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

  Future _refreshAgenda() async {
    BlocProvider.of<AgendaBloc>(context).add(UpdateAllAgenda());
    BlocProvider.of<AgendaBloc>(context).add(GetAllAgenda());
    _refreshController.refreshFailed();
  }
}
