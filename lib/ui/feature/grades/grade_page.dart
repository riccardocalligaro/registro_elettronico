import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/grades/grades_bloc.dart';
import 'package:registro_elettronico/ui/bloc/periods/bloc.dart';
import 'package:registro_elettronico/ui/feature/grades/chart/grades_chart.dart';
import 'package:registro_elettronico/ui/feature/grades/grade_tab.dart';
import 'package:registro_elettronico/ui/feature/widgets/app_drawer.dart';
import 'package:registro_elettronico/ui/feature/widgets/custom_app_bar.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/constants/drawer_constants.dart';

class GradesPage extends StatefulWidget {
  GradesPage({Key key}) : super(key: key);

  @override
  _GradesPageState createState() => _GradesPageState();
}

class _GradesPageState extends State<GradesPage>
    with AutomaticKeepAliveClientMixin {
  List<Color> gradientColors = [Colors.red[400], Colors.white];

  bool showAvg = false;

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  bool get wantKeepAlive => false;

  @override
  void initState() {
    print("init");
    super.initState();
  }

  @override
  void dispose() {
    print("init");
    super.dispose();
  }

  @override
  void setState(fn) {
    print("state");
    super.setState(fn);
  }

  @override
  void didChangeDependencies() {
    BlocProvider.of<PeriodsBloc>(context).add(GetPeriods());
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocBuilder<PeriodsBloc, PeriodsState>(
      builder: (context, state) {
        if (state is PeriodsLoaded) {
          final periods = state.periods;
          return DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0.0,
                textTheme: Theme.of(context).textTheme,
                bottom: TabBar(
                  indicatorColor: Colors.black,
                  labelColor: Colors.black,
                  tabs: _getTabBar(periods),
                ),
                title: Text(AppLocalizations.of(context).translate('grades')),
              ),
              drawer: AppDrawer(
                profileDao: Injector.appInstance.getDependency(),
                position: DrawerConstants.GRADES,
              ),
              body: TabBarView(
                children: _getTabsSections(periods),
              ),
            ),
          );
        }
        return _buildLoadingScaffold();
      },
    );
  }

  /// Take the periods from spaggiari and add the general tab
  List<Widget> _getTabBar(List<Period> periods) {
    if (mounted) {
      List tabs = periods
          .map((period) => Tab(
                child: Text(period.code),
              ))
          .toList();
      tabs.add(Tab(
        child: Text('Generale'),
      ));
      return tabs;
    }
  }

  /// This function is for selecting the respective tab in the tab layout
  List<Widget> _getTabsSections(List<Period> periods) {
    super.build(context);
    if (mounted) {
      return List.generate(periods.length + 1, (index) {
        if (index >= periods.length) {
          return GradeTab(
            period: -1,
          );
        } else {
          return GradeTab(
            period: periods[index].position,
          );
        }

        return StreamBuilder(
          stream: BlocProvider.of<GradesBloc>(context).watchAllGradesOrdered(),
          initialData: List<Grade>(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            final List<Grade> grades = snapshot.data ?? List<Grade>();
            // final gradesOfPeriod = grades
            //     .where((grade) => grade.periodPos == periods[index].position)
            //     .toList();
            if (mounted) {
              return Text('ocp');
            }
            // return Text('ocp');
            //return GradesSection(
            //    grades: index > periods.length + 1 ? gradesOfPeriod : grades);
          },
        );
      });
    }
  }

  /// Loading scaffold while periods are loading
  Scaffold _buildLoadingScaffold() {
    return Scaffold(
      key: _drawerKey,
      appBar: CustomAppBar(
        scaffoldKey: _drawerKey,
        title: AppLocalizations.of(context).translate('grades'),
      ),
      drawer: AppDrawer(
        profileDao: Injector.appInstance.getDependency(),
        position: DrawerConstants.GRADES,
      ),
      body: Container(
        child: Center(
          child: CircularProgressIndicator(
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }

  /// Stream builder for the average chart
  StreamBuilder _buildChart() {
    return StreamBuilder(
      stream: BlocProvider.of<GradesBloc>(context).watchAllGradesOrdered(),
      initialData: List<Grade>(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return GradesChart(
          grades: snapshot.data,
        );
      },
    );
  }
}
