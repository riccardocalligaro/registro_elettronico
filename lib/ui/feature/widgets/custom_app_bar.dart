import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:registro_elettronico/data/db/dao/lesson_dao.dart';
import 'package:registro_elettronico/ui/bloc/agenda/agenda_bloc.dart';
import 'package:registro_elettronico/ui/bloc/agenda/agenda_event.dart';
import 'package:registro_elettronico/ui/bloc/grades/grades_bloc.dart';
import 'package:registro_elettronico/ui/bloc/grades/grades_event.dart';
import 'package:registro_elettronico/ui/bloc/lessons/bloc.dart';
import 'package:registro_elettronico/ui/bloc/subjects/subjects_bloc.dart';
import 'package:registro_elettronico/ui/bloc/subjects/subjects_event.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  // the title in the app bar
  final String title;
  // this is the state for opening and closing the drawer
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CustomAppBar(
      {Key key, @required this.title, @required this.scaffoldKey})
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
          },
        ),
        IconButton(
          icon: Icon(
            Icons.delete,
            color: Colors.black,
          ),
          onPressed: () {
            final lessonDao = LessonDao(Injector.appInstance.getDependency());
            lessonDao.deleteLessons();
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
