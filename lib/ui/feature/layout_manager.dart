import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:registro_elettronico/data/db/dao/lesson_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/agenda/bloc.dart';
import 'package:registro_elettronico/ui/bloc/auth/bloc.dart';
import 'package:registro_elettronico/ui/bloc/grades/bloc.dart';
import 'package:registro_elettronico/ui/bloc/lessons/bloc.dart';
import 'package:registro_elettronico/ui/bloc/subjects/bloc.dart';
import 'package:registro_elettronico/ui/feature/briefing/briefing_page.dart';
import 'package:registro_elettronico/ui/feature/lessons/lessons_page.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class LayoutManager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LayoutManagerState();
  }
}

class LayoutManagerState extends State<LayoutManager> {
  int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return BriefingPage();
      case 1:
        return LessonsPage();

      default:
        return Text("Error");
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions = [];
    List titles = _createList(context);
    for (var i = 0; i < titles.length; i++) {
      var d = titles[i];
      drawerOptions.add(ListTile(
        leading: Icon(d.icon),
        title: Text(d.title),
        selected: i == _selectedDrawerIndex,
        onTap: () => _onSelectItem(i),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        textTheme: Theme.of(context).textTheme,
        elevation: 0.0,
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
            icon: Icon(Icons.present_to_all),
            onPressed: () {
              BlocProvider.of<LessonsBloc>(context).add(FetchAllLessons());
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
        title: Text(
          titles[_selectedDrawerIndex].title,
          style: TextStyle(color: Colors.black),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            _buildAccountHeader(),
            Column(children: drawerOptions)
          ],
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }

  List _createList(BuildContext context) {
    final trans = AppLocalizations.of(context);
    final drawerItems = [
      DrawerItem(trans.translate('app_name'), Icons.home),
      DrawerItem(trans.translate('lessons'), Icons.library_books),
      DrawerItem(trans.translate('grades'), Icons.timeline),
      DrawerItem(trans.translate('agenda'), Icons.event),
      DrawerItem(trans.translate('school_material'), Icons.folder),
      DrawerItem(trans.translate('absences'), Icons.assessment),
      DrawerItem(trans.translate('notes'), Icons.info),
      DrawerItem(trans.translate('notice_board'), Icons.assignment),
      DrawerItem(trans.translate('settings'), Icons.settings),
      DrawerItem(trans.translate('share'), Icons.share),
      DrawerItem(trans.translate('contact_us'), Icons.send),
    ];
    return drawerItems;
  }

  Widget _buildAccountHeader() {
    return FutureBuilder(
      future: _getUsername(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        String ident = " ";
        String firstName = " ";
        String lastName = " ";

        if (snapshot.data != null) {
          ident = snapshot.data.ident;
          firstName = snapshot.data.firstName;
          lastName = snapshot.data.lastName;
        }

        return UserAccountsDrawerHeader(
          accountEmail: Text(ident),
          accountName: Text("$firstName $lastName"),
          currentAccountPicture: CircleAvatar(
            child: Text(firstName[0] + lastName[0]),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          decoration: BoxDecoration(color: Theme.of(context).accentColor),
        );
      },
    );
  }

  Future<Profile> _getUsername() async {
    return await BlocProvider.of<AuthBloc>(context).profile;
  }
}
