import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/core/infrastructure/navigator.dart';
import 'package:registro_elettronico/core/presentation/widgets/app_drawer.dart';
import 'package:registro_elettronico/core/presentation/widgets/last_update_bottom_sheet.dart';
import 'package:registro_elettronico/feature/grades/presentation/views/last_grades_page.dart';
import 'package:registro_elettronico/feature/grades/presentation/views/term_grades_page.dart';
import 'package:registro_elettronico/utils/constants/drawer_constants.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:registro_elettronico/utils/constants/tabs_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/subjects_grades/subjects_grades_bloc.dart';

class GradesPage extends StatefulWidget {
  GradesPage({Key key}) : super(key: key);

  @override
  _GradesPageState createState() => _GradesPageState();
}

class _GradesPageState extends State<GradesPage> {
  int _lastUpdateGrades;

  @override
  void initState() {
    getPreferences();
    super.initState();
    BlocProvider.of<SubjectsGradesBloc>(context).add(GetGradesAndSubjects());
  }

  void getPreferences() async {
    SharedPreferences sharedPreferences = sl();
    setState(() {
      _lastUpdateGrades =
          sharedPreferences.getInt(PrefsConstants.lastUpdateGrades);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubjectsGradesBloc, SubjectsGradesState>(
      builder: (context, state) {
        if (state is SubjectsGradesLoadSuccess) {
          state.grades.sort((b, a) => a.eventDate.compareTo(b.eventDate));

          return DefaultTabController(
            length: 4,
            child: Scaffold(
              appBar: AppBar(
                brightness: Theme.of(context).brightness,
                elevation: 0.0,
                textTheme: Theme.of(context).textTheme,
                iconTheme: Theme.of(context).primaryIconTheme,
                bottom: TabBar(
                  isScrollable: true,
                  indicatorColor: Colors.red,
                  labelColor:
                      Theme.of(context).primaryTextTheme.headline5.color,
                  tabs: _getTabBar(),
                ),
                title: Text(AppLocalizations.of(context).translate('grades')),
              ),
              bottomSheet: LastUpdateBottomSheet(
                millisecondsSinceEpoch: _lastUpdateGrades,
              ),
              body: BlocListener<SubjectsGradesBloc, SubjectsGradesState>(
                listener: (context, state2) {
                  if (state2 is SubjectsGradesUpdateLoadSuccess) {
                    setState(() {
                      _lastUpdateGrades = DateTime.now().millisecondsSinceEpoch;
                    });
                  }

                  if (state2 is SubjectsGradesLoadNotConnected) {
                    Scaffold.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(AppNavigator.instance
                          .getNetworkErrorSnackBar(context));
                  }
                },
                child: state.periods.isNotEmpty
                    ? TabBarView(
                        children: <Widget>[
                          LastGradesPage(
                            grades: state.grades,
                          ),
                          TermGradesPage(
                            grades: state.grades,
                            subjects: state.subjects,
                            objectives: state.objectives,
                            periodPosition: state.periods
                                .where((p) => p.periodIndex == 1)
                                .single
                                .position,
                            generalObjective: state.generalObjective,
                          ),
                          TermGradesPage(
                            grades: state.grades,
                            subjects: state.subjects,
                            objectives: state.objectives,
                            periodPosition: state.periods
                                .where((p) => p.periodIndex == 2)
                                .single
                                .position,
                            generalObjective: state.generalObjective,
                          ),
                          TermGradesPage(
                            grades: state.grades,
                            subjects: state.subjects,
                            objectives: state.objectives,
                            periodPosition: TabsConstants.GENERALE,
                            generalObjective: state.generalObjective,
                          )
                        ],
                      )
                    : TabBarView(
                        children: <Widget>[
                          LastGradesPage(
                            grades: state.grades,
                          ),
                          TermGradesPage(
                            grades: state.grades,
                            subjects: state.subjects,
                            objectives: state.objectives,
                            periodPosition: 1,
                            generalObjective: state.generalObjective,
                          ),
                          TermGradesPage(
                            grades: state.grades,
                            subjects: state.subjects,
                            objectives: state.objectives,
                            periodPosition: 2,
                            generalObjective: state.generalObjective,
                          ),
                          TermGradesPage(
                            grades: state.grades,
                            subjects: state.subjects,
                            objectives: state.objectives,
                            periodPosition: TabsConstants.GENERALE,
                            generalObjective: state.generalObjective,
                          )
                        ],
                      ),
              ),
            ),
          );
        } else {
          return DefaultTabController(
            length: 4,
            child: Scaffold(
                appBar: AppBar(
                  elevation: 0.0,
                  textTheme: Theme.of(context).textTheme,
                  iconTheme: Theme.of(context).primaryIconTheme,
                  bottom: TabBar(
                    isScrollable: true,
                    indicatorColor: Colors.red,
                    labelColor:
                        Theme.of(context).primaryTextTheme.headline5.color,
                    tabs: _getTabBar(),
                  ),
                  title: Text(AppLocalizations.of(context).translate('grades')),
                ),
                drawer: AppDrawer(
                  position: DrawerConstants.GRADES,
                ),
                body: Center(
                  child: CircularProgressIndicator(),
                )),
          );
        }
      },
    );
  }

  List<Widget> _getTabBar() {
    List<Widget> tabs = [];

    tabs.add(
      Container(
        width: 140,
        child: Tab(
          child: Text(AppLocalizations.of(context)
              .translate('last_grades')
              .toUpperCase()),
        ),
      ),
    );

    tabs.add(
      Container(
        width: 140,
        child: Tab(
          child: Text(
              "1° ${AppLocalizations.of(context).translate('term').toUpperCase()}"),
        ),
      ),
    );

    tabs.add(
      Container(
        width: 140,
        child: Tab(
          child: Text(
              "2° ${AppLocalizations.of(context).translate('term').toUpperCase()}"),
        ),
      ),
    );

    tabs.add(Container(
      width: 140,
      child: Tab(
        child: Text(
          AppLocalizations.of(context).translate('overall').toUpperCase(),
        ),
      ),
    ));

    return tabs;
  }
}
