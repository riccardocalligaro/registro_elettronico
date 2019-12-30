import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:intl/intl.dart';
import 'package:random_color/random_color.dart';
import 'package:registro_elettronico/data/db/dao/lesson_dao.dart';
import 'package:registro_elettronico/data/db/dao/timetable_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/timetable/bloc.dart';
import 'package:registro_elettronico/ui/feature/widgets/app_drawer.dart';
import 'package:registro_elettronico/ui/feature/widgets/cusotm_placeholder.dart';
import 'package:registro_elettronico/ui/feature/widgets/custom_app_bar.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/constants/drawer_constants.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:registro_elettronico/utils/global_utils.dart';
import 'package:registro_elettronico/utils/string_utils.dart';

class TimetablePage extends StatefulWidget {
  const TimetablePage({Key key}) : super(key: key);

  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  @override
  void initState() {
    BlocProvider.of<TimetableBloc>(context).add(GetTimetable());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
    final date = DateTime.utc(2019, 12, 10);

    return Scaffold(
      key: _drawerKey,
      appBar: CustomAppBar(
        scaffoldKey: _drawerKey,
        title: Text(
          AppLocalizations.of(context).translate('timetable'),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              BlocProvider.of<TimetableBloc>(context).add(
                GetNewTimetable(
                  begin: date,
                  end: date.add(Duration(days: 6)),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              final TimetableDao timetableDao =
                  TimetableDao(Injector.appInstance.getDependency());
              await timetableDao.deleteTimetable();
            },
          )
        ],
      ),
      drawer: AppDrawer(
        position: DrawerConstants.TIMETABLE,
      ),
      body: BlocBuilder<TimetableBloc, TimetableState>(
        builder: (context, state) {
          if (state is TimetableLoading) {
            return _buildTimetableLoading();
          }

          if (state is TimetableError) {
            return _buildTimetableError(state.error);
          }

          if (state is TimetableLoaded) {
            return _buildTimetableList(state.timetable);
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildTimetableList(Map<DateTime, List<TimetableEntry>> timetable) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: timetable.keys.length,
      itemBuilder: (context, index) {
        final date = timetable.keys.elementAt(index);
        List<TimetableEntry> lessons = timetable[date];
        return Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(StringUtils.capitalize(
                      DateUtils.convertSingleDayForDisplay(date,
                          AppLocalizations.of(context).locale.toString()))),
                ),
                IgnorePointer(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: lessons.length,
                    itemBuilder: (context, index) {
                      final lesson = lessons[index];
                      return Card(
                        color: GlobalUtils.getColorFromPosition(lesson.position),
                        child: ListTile(
                          title: Text(lesson.subject, style: TextStyle(color: Colors.white),),
                          subtitle: Text('${lesson.duration}H', style: TextStyle(color: Colors.white),),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimetableLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildTimetableError(String error) {
    return CustomPlaceHolder(
      text: error ??
          AppLocalizations.of(context).translate('unexcepted_error_single'),
      icon: Icons.error,
      showUpdate: true,
      onTap: () {
        BlocProvider.of<TimetableBloc>(context).add(GetTimetable());
      },
    );
  }
}
