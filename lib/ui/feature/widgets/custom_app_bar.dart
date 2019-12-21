import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:registro_elettronico/data/db/dao/agenda_dao.dart';
import 'package:registro_elettronico/data/db/dao/lesson_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart' as db;
import 'package:registro_elettronico/ui/bloc/agenda/agenda_bloc.dart';
import 'package:registro_elettronico/ui/bloc/agenda/agenda_event.dart';
import 'package:registro_elettronico/ui/bloc/grades/grades_bloc.dart';
import 'package:registro_elettronico/ui/bloc/grades/grades_event.dart';
import 'package:registro_elettronico/ui/bloc/lessons/bloc.dart';
import 'package:registro_elettronico/ui/bloc/periods/periods_bloc.dart';
import 'package:registro_elettronico/ui/bloc/periods/periods_event.dart';
import 'package:registro_elettronico/ui/bloc/subjects/subjects_bloc.dart';
import 'package:registro_elettronico/ui/bloc/subjects/subjects_event.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  // the title in the app bar
  final String title;
  // this is the state for opening and closing the drawer
  final GlobalKey<ScaffoldState> scaffoldKey;
  //  tab bar
  final TabBar tabBar;

  const CustomAppBar(
      {Key key, @required this.title, @required this.scaffoldKey, this.tabBar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // We get the title from the constructor parameters
      title: Text(
        // Black text
        title,
        style: TextStyle(color: Colors.black),
      ),

      // We want this AppBar to have no shadow
      elevation: 0.0,
      // White background color
      backgroundColor: Colors.white,

      bottom: tabBar,
      // Open Drawer Button
      leading: IconButton(
        // We want a black Icon
        icon: Icon(
          Icons.menu,
          color: Colors.black,
        ),
        onPressed: () {
          scaffoldKey.currentState.openDrawer();
        },
      ),

      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.refresh,
            color: Colors.black,
          ),
          onPressed: () {
            BlocProvider.of<LessonsBloc>(context).add(FetchTodayLessons());
            BlocProvider.of<AgendaBloc>(context).add(FetchAgenda());
            BlocProvider.of<SubjectsBloc>(context).add(FetchSubjects());
            BlocProvider.of<GradesBloc>(context).add(FetchGrades());
            BlocProvider.of<PeriodsBloc>(context).add(FetchPeriods());
          },
        ),
        IconButton(
          icon: Icon(Icons.all_out),
          onPressed: () {
            BlocProvider.of<LessonsBloc>(context).add(FetchAllLessons());
          },
        ),
        IconButton(
          icon: Icon(
            Icons.delete,
            color: Colors.black,
          ),
          onPressed: () async {
            await db.AppDatabase().resetDbWithoutProfile();
          },
        ),
        IconButton(
          icon: Icon(
            Icons.casino,
            color: Colors.black,
          ),
          onPressed: () {
            final agendaDao = AgendaDao(Injector.appInstance.getDependency());
            final db.AgendaEvent event = db.AgendaEvent(
                evtId: 343432434232133121,
                authorName: "Gidasanno",
                notes: "Hidas!",
                classDesc: "4idasa",
                subjectDesc: "Infodasrmatica",
                end: DateTime.utc(2019, 9, 30),
                begin: DateTime.utc(2019, 9, 30),
                evtCode: "839masdasdds",
                isFullDay: false,
                subjectId: 0);
            agendaDao.insertEvent(event);
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
