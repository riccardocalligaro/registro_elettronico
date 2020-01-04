import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
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
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

import '../../bloc/timetable/timetable_event.dart';

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
    BlocProvider.of<TimetableBloc>(context).add(
      GetNewTimetable(
        begin: DateTime.now(),
        end: DateTime.now().add(Duration(days: 6)),
      ),
    );
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
            onPressed: () async {
              final List<DateTime> picked = await DateRagePicker.showDatePicker(
                context: context,
                initialFirstDate: DateTime.now(),
                initialLastDate: (DateTime.now()).add(Duration(days: 6)),
                firstDate: DateTime(2015),
                lastDate: DateTime(2021),
              );
              if (picked != null && picked.length == 2) {
                BlocProvider.of<TimetableBloc>(context).add(
                  GetNewTimetable(
                    begin: picked[0],
                    end: picked[0].add(Duration(days: 6)),
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              final TimetableDao timetableDao =
                  TimetableDao(Injector.appInstance.getDependency());
              await timetableDao.deleteTimetable();
              BlocProvider.of<TimetableBloc>(context).add(GetTimetable());
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
            if (state.timetableEntries.length > 0)
              return _buildTimetableList(state.timetableEntries, state.subjects);

            return CustomPlaceHolder(
              icon: Icons.access_time,
              text: 'No timetable',
              showUpdate: true,
              onTap: () {
                BlocProvider.of<TimetableBloc>(context).add(
                  GetNewTimetable(
                    begin: date,
                    end: date.add(Duration(days: 6)),
                  ),
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildTimetableList(List<TimetableEntry> timetable, List<Subject> subjects) {
    
    return ListView.builder(
      shrinkWrap: true,
      itemCount: timetable.length,
      itemBuilder: (context, index) {
        final entry = timetable[index];
        return Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(entry.dayOfWeek.toString()),
                ),
                Card(
                  child: ListTile(
                    title: Text(
                      subjects.where((s) => s.id == entry.subject).single.name ?? '',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      '${entry.start}H',
                      style: TextStyle(color: Colors.white),
                    ),
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
