import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/agenda/agenda_bloc.dart';
import 'package:registro_elettronico/ui/bloc/lessons/lessons_bloc.dart';
import 'package:registro_elettronico/ui/feature/widgets/app_drawer.dart';
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

  DateTime _currentSelectedDay;
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();

    _selectedEvents = [];
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    setState(() {
      _selectedEvents = events;
      _currentSelectedDay = day;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      appBar: CustomAppBar(
        scaffoldKey: _drawerKey,
        title: Text(AppLocalizations.of(context).translate('agenda')),
      ),
      drawer: AppDrawer(
        profileDao: Injector.appInstance.getDependency(),
        position: DrawerConstants.AGENDA,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildTableCalendar(),
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
              child: _buildLessonsList(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTableCalendar() {
    return StreamBuilder(
      stream: BlocProvider.of<AgendaBloc>(context).watchAgenda(),
      initialData: List<AgendaEvent>(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final List<AgendaEvent> events = snapshot.data ?? List<AgendaEvent>();

        final Map<DateTime, List<AgendaEvent>> eventsMap = Map.fromIterable(
            events,
            key: (e) => e.begin,
            value: (e) => events
                .where((event) => DateUtils.areSameDay(event.begin, e.begin))
                .toSet()
                .toList());
        return TableCalendar(
          calendarController: _calendarController,
          events: eventsMap,
          startingDayOfWeek: StartingDayOfWeek.monday,
          weekendDays: const [DateTime.sunday],
          calendarStyle: CalendarStyle(
              selectedColor: Colors.red[400],
              todayColor: Colors.red[200],
              markersColor: Colors.red[700],
              outsideDaysVisible: true,
              outsideStyle: TextStyle(color: Colors.grey[300]),
              outsideWeekendStyle: TextStyle(color: Colors.red[100]),
              weekendStyle: TextStyle(color: Colors.red)),
          headerStyle: HeaderStyle(
              formatButtonTextStyle:
                  TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
              formatButtonDecoration: BoxDecoration(
                color: Colors.deepOrange[400],
                borderRadius: BorderRadius.circular(16.0),
              ),
              formatButtonVisible: false),
          onDaySelected: _onDaySelected,
          onVisibleDaysChanged: _onVisibleDaysChanged,
        );
      },
    );
  }

  Widget _buildLessonsList() {
    return StreamBuilder(
      stream: BlocProvider.of<LessonsBloc>(context)
          .watchLessonsByDate(_currentSelectedDay ?? DateTime.now()),
      initialData: List<Lesson>(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final List<Lesson> lessons = snapshot.data ?? List<Lesson>();
        if (lessons.length == 0) {
          return Center(
              child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(AppLocalizations.of(context).translate('nothing_here')),
          ));
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
      },
    );
  }

  Widget _buildEventList() {
    if (_selectedEvents.length == 0) {
      return Center(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(AppLocalizations.of(context).translate('free_to_go')),
      ));
    }
    return IgnorePointer(
      child: ListView(
          shrinkWrap: true,
          children: _selectedEvents.map((e) {
            final AgendaEvent event = e;
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
