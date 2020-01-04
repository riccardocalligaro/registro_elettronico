import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/data/db/moor_database.dart' as db;
import 'package:registro_elettronico/ui/bloc/agenda/agenda_bloc.dart';
import 'package:registro_elettronico/ui/bloc/agenda/bloc.dart';
import 'package:registro_elettronico/ui/bloc/lessons/bloc.dart';
import 'package:registro_elettronico/ui/bloc/lessons/lessons_bloc.dart';
import 'package:registro_elettronico/ui/feature/widgets/app_drawer.dart';
import 'package:registro_elettronico/ui/feature/widgets/cusotm_placeholder.dart';
import 'package:registro_elettronico/ui/feature/widgets/custom_app_bar.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/constants/drawer_constants.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:registro_elettronico/utils/string_utils.dart';
import 'package:table_calendar/table_calendar.dart';

class AgendaPage extends StatefulWidget {
  AgendaPage({Key key}) : super(key: key);

  @override
  _AgendaPageState createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
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
      DateTime first, DateTime last, CalendarFormat format) {}

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AgendaBloc>(context).add(GetAllAgenda());

    return Scaffold(
      key: _drawerKey,
      appBar: CustomAppBar(
        scaffoldKey: _drawerKey,
        title: Text(AppLocalizations.of(context).translate('agenda')),
      ),
      drawer: AppDrawer(
        position: DrawerConstants.AGENDA,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildAgendaBlocBuilder(),
            const SizedBox(height: 8.0),
            const SizedBox(height: 8.0),
            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 8.0),
              child: Text(
                AppLocalizations.of(context).translate('events'),
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              child: _buildEventList(),
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
    );
  }

  Widget _buildAgendaBlocBuilder() {
    return BlocBuilder<AgendaBloc, AgendaState>(
      builder: (context, state) {
        if (state is AgendaUpdateLoadInProgress) {
          return Center(
            child: CircularProgressIndicator(),
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
          .toSet()
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
        outsideDaysVisible: true,
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
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: ListView.builder(
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
      ),
    );
  }

  Widget _buildEventList() {
    if (_selectedEvents.length == 0) {
      return Padding(
        padding: const EdgeInsets.only(top: 32.0),
        child: CustomPlaceHolder(
          icon: Icons.calendar_today,
          showUpdate: false,
          text: '',
        ),
      );
    }
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
                  title: Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                    child: Text(
                      StringUtils.titleCase(event.authorName),
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                    child: Text(
                      event.notes,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            );
          }).toList()),
    );
  }
}
