import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/periods/bloc.dart';
import 'package:registro_elettronico/ui/feature/grades/components/grades_tab.dart';
import 'package:registro_elettronico/ui/feature/widgets/app_drawer.dart';
import 'package:registro_elettronico/ui/feature/widgets/custom_app_bar.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/constants/drawer_constants.dart';
import 'package:registro_elettronico/utils/constants/tabs_constants.dart';
import 'package:registro_elettronico/utils/global_utils.dart';

class GradesPage extends StatefulWidget {
  GradesPage({Key key}) : super(key: key);

  @override
  _GradesPageState createState() => _GradesPageState();
}

class _GradesPageState extends State<GradesPage> {
  List<Color> gradientColors = [Colors.red[400], Colors.white];

  bool showAvg = false;

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  void didChangeDependencies() {
    BlocProvider.of<PeriodsBloc>(context).add(GetPeriods());
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PeriodsBloc, PeriodsState>(
      builder: (context, state) {
        if (state is PeriodsLoaded) {
          final periods = state.periods;
          return DefaultTabController(
            length: periods.length + 2,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0.0,
                textTheme: Theme.of(context).textTheme,
                bottom: TabBar(
                  isScrollable: true,
                  indicatorColor: Colors.red,
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
    tabs.addAll(
      periods.map(
        (period) => Container(
          width: 140,
          child: Tab(
            child: Text(
              GlobalUtils.getPeriodName(period.position, context),
            ),
          ),
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

  /// This function is for selecting the respective tab in the tab layout
  List<Widget> _getTabsSections(List<Period> periods) {
    return List.generate(
      periods.length + 2,
      (index) {
        // If its last marks use the constants for last marks
        if (index == 0) {
          return GradeTab(period: TabsConstants.ULTIMI_VOTI);
        }
        if (index >= periods.length + 1) {
          return GradeTab(
            period: TabsConstants.GENERALE,
          );
        } else {
          return GradeTab(
            period: periods[index - 1].position,
          );
        }
      },
    );
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
  // StreamBuilder _buildChart() {
  //   return StreamBuilder(
  //     stream: BlocProvider.of<GradesBloc>(context).watchAllGradesOrdered(),
  //     initialData: List<Grade>(),
  //     builder: (BuildContext context, AsyncSnapshot snapshot) {
  //       return GradesChart(
  //         grades: snapshot.data,
  //       );
  //     },
  //   );
  // }
}
