import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/feature/agenda/presentation/agenda_page.dart';
import 'package:registro_elettronico/feature/grades/presentation/grades_page.dart';
import 'package:registro_elettronico/feature/home/home_page.dart';
import 'package:registro_elettronico/feature/navigator/more_page.dart';
import 'package:registro_elettronico/feature/noticeboard/presentation/noticeboard_page.dart';

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
          MorePage(),
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
          label: AppLocalizations.of(context).translate('home'),
          icon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          label: AppLocalizations.of(context).translate('grades'),
          icon: Icon(
            Icons.class_,
          ),
        ),
        BottomNavigationBarItem(
          label: AppLocalizations.of(context).translate('agenda'),
          icon: Icon(
            Icons.today,
            size: 25,
          ),
        ),
        BottomNavigationBarItem(
          label: AppLocalizations.of(context).translate('notice_board'),
          icon: Icon(Icons.email),
        ),
        BottomNavigationBarItem(
          label: '',
          icon: Icon(Icons.more_horiz),
        ),
      ],
    );
  }
}
