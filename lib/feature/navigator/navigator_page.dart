import 'package:flutter/material.dart';
import 'package:registro_elettronico/feature/agenda/presentation/agenda_page.dart';
import 'package:registro_elettronico/feature/grades/presentation/grades_page.dart';
import 'package:registro_elettronico/feature/home/home_page.dart';
import 'package:registro_elettronico/feature/noticeboard/presentation/noticeboard_page.dart';
import 'package:registro_elettronico/feature/settings/settings_page.dart';

class NavigatorPage extends StatefulWidget {
  NavigatorPage({Key key}) : super(key: key);

  @override
  _NavigatorPageState createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomNavigationBar(),
      body: IndexedStack(
        index: _currentPage,
        children: [
          HomePage(),
          GradesPage(),
          AgendaPage(),
          NoticeboardPage(),
          SettingsPage(),
        ],
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).cardTheme.color,
      // selectedItemColor: CYColors.lightOrange,
      // unselectedItemColor: CYColors.lightText,
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentPage,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (int index) {
        setState(() {
          _currentPage = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          // title: Container(),
          label: 'Home',
          icon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          label: '',
          icon: Icon(Icons.timeline),
        ),
        BottomNavigationBarItem(
          label: '',
          icon: Icon(Icons.calendar_today),
        ),
        BottomNavigationBarItem(
          label: '',
          icon: Icon(Icons.assessment),
        ),
        BottomNavigationBarItem(
          label: '',
          icon: Icon(Icons.more_horiz),
        ),
      ],
    );
  }
}
