import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:registro_elettronico/data/db/dao/lesson_dao.dart';
import 'package:registro_elettronico/domain/entity/genius_timetable.dart';
import 'package:registro_elettronico/ui/feature/widgets/app_drawer.dart';
import 'package:registro_elettronico/ui/feature/widgets/custom_app_bar.dart';
import 'package:registro_elettronico/utils/constants/drawer_constants.dart';

class TimetablePage extends StatelessWidget {
  const TimetablePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
    final LessonDao lessonDao = LessonDao(Injector.appInstance.getDependency());
    lessonDao.getGeniusTimetable();
    return Scaffold(
      key: _drawerKey,
      appBar: CustomAppBar(
        scaffoldKey: _drawerKey,
        title: Text('Timetable'),
      ),
      drawer: AppDrawer(
        position: DrawerConstants.TIMETABLE,
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: Text('Tiemtable'),
            onPressed: () {
              lessonDao.getGeniusTimetable();
            },
          ),
          FutureBuilder(
            future: lessonDao.getGeniusTimetable(),
            initialData: [],
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              final List<GeniusTimetable> geniusTimetable = snapshot.data;
              return ListView.builder(
                shrinkWrap: true,
                itemCount: geniusTimetable.length,
                itemBuilder: (ctx, index) {
                  return Text(geniusTimetable[index].teacher);
                },
              );
            },
          ),
        ],
      ),
    ); 
  }
}
