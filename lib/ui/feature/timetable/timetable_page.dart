import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:injector/injector.dart';
import 'package:intl/intl.dart';
import 'package:registro_elettronico/data/db/dao/timetable_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/timetable/bloc.dart';
import 'package:registro_elettronico/ui/feature/widgets/app_drawer.dart';
import 'package:registro_elettronico/ui/feature/widgets/cusotm_placeholder.dart';
import 'package:registro_elettronico/ui/feature/widgets/custom_app_bar.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/constants/drawer_constants.dart';
import 'package:registro_elettronico/utils/date_utils.dart';

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

    return Scaffold(
      key: _drawerKey,
      appBar: CustomAppBar(
        scaffoldKey: _drawerKey,
        title: Text(
          AppLocalizations.of(context).translate('timetable'),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.sync),
            onPressed: () async {
              BlocProvider.of<TimetableBloc>(context).add(GetNewTimetable());
              BlocProvider.of<TimetableBloc>(context).add(GetTimetable());
            },
          ),
        ],
      ),
      drawer: AppDrawer(
        position: DrawerConstants.TIMETABLE,
      ),
      body: Container(
        child: BlocBuilder<TimetableBloc, TimetableState>(
          builder: (context, state) {
            if (state is TimetableLoading) {
              return _buildTimetableLoading();
            }

            if (state is TimetableError) {
              return _buildTimetableError(state.error);
            }

            if (state is TimetableLoaded) {
              if (state.timetableEntries.length > 0)
                return _buildTimetableList(
                    state.timetableEntries, state.subjects);

              return CustomPlaceHolder(
                icon: Icons.access_time,
                text: 'No timetable',
                showUpdate: true,
                onTap: () {},
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildTimetableList(
      List<TimetableEntry> timetable, List<Subject> subjects) {
    return ListView.builder(
      itemCount: 7,
      shrinkWrap: true,
      //scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        if (index != 0) {
          final List<TimetableEntry> entries =
              timetable.where((t) => t.dayOfWeek == index).toList();
          entries.sort((a, b) => a.start.compareTo(b.start));
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 21.0),
                child: Text(
                  DateUtils.convertSingleDayForDisplay(
                      DateTime.utc(2000, 1, 2).add(Duration(days: index)),
                      AppLocalizations.of(context).locale.toString()),
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: entries.length,
                shrinkWrap: true,
                itemBuilder: (context, index2) {
                  final entry = entries[index2];
                  return Column(
                    children: <Widget>[
                      ListTile(
                        leading: Text('${entry.start}H'),
                        title: Text(
                          subjects
                              .where((s) => s.id == entry.subject)
                              .single
                              .name,
                        ),
                      ),
                      Divider(),
                    ],
                  );
                },
              )
            ],
          );
        }
        return Container();
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
