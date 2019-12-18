import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/grades/grades_bloc.dart';
import 'package:registro_elettronico/ui/feature/grades/chart/grades_chart.dart';
import 'package:registro_elettronico/ui/feature/widgets/app_drawer.dart';
import 'package:registro_elettronico/ui/feature/widgets/custom_app_bar.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/constants/drawer_constants.dart';

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
  Widget build(BuildContext context) {
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
      body: _buildChart(),
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
