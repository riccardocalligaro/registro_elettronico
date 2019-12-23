import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/absences/absences_bloc.dart';
import 'package:registro_elettronico/ui/bloc/absences/absences_event.dart';
import 'package:registro_elettronico/ui/bloc/absences/absences_state.dart';
import 'package:registro_elettronico/ui/feature/absences/components/absence_card.dart';
import 'package:registro_elettronico/ui/feature/widgets/app_drawer.dart';
import 'package:registro_elettronico/ui/feature/widgets/cusotm_placeholder.dart';
import 'package:registro_elettronico/ui/feature/widgets/custom_app_bar.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/constants/drawer_constants.dart';
import 'package:registro_elettronico/utils/constants/registro_constants.dart';

import 'components/absences_chart_lines.dart';

class AbsencesPage extends StatefulWidget {
  const AbsencesPage({Key key}) : super(key: key);

  @override
  _AbsencesPageState createState() => _AbsencesPageState();
}

class _AbsencesPageState extends State<AbsencesPage>
    with AutomaticKeepAliveClientMixin {
  @override
  void didChangeDependencies() {
    BlocProvider.of<AbsencesBloc>(context).add(GetAbsences());
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

    return Scaffold(
      key: _drawerKey,
      appBar: CustomAppBar(
        scaffoldKey: _drawerKey,
        title: Text(AppLocalizations.of(context).translate('absences')),
      ),
      drawer: AppDrawer(
        profileDao: Injector.appInstance.getDependency(),
        position: DrawerConstants.ABSENCES,
      ),
      body: RefreshIndicator(
        onRefresh: _updateAbsences,
        child: SingleChildScrollView(
          child: _buildAbsences(context),
        ),
      ),
    );
  }

  Widget _buildAbsences(BuildContext context) {
    return BlocBuilder<AbsencesBloc, AbsencesState>(
      builder: (context, state) {
        if (state is AbsencesLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is AbsencesLoaded) {
          final List<Absence> absences = state.absences ?? List<Absence>();
          final map = getAbsencesMap(
              absences..sort((b, a) => a.evtDate.compareTo(b.evtDate)));

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: _buildOverallStats(absences),
                ),
                _buildNotJustifiedAbsences(map),
                _buildJustifiedAbsences(map, context),
              ],
            ),
          );
        }

        if (state is AbsencesError) {
          return CustomPlaceHolder(
            text: AppLocalizations.of(context)
                .translate('unexcepted_error_single'),
            icon: Icons.error,
            onTap: () {
              BlocProvider.of<AbsencesBloc>(context).add(GetAbsences());
            },
            showUpdate: true,
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  /// Overall stat that contains all the [circles] and the [graph]
  Widget _buildOverallStats(List<Absence> absences) {
    final Map<int, List<Absence>> absencesMonthMap = Map.fromIterable(absences,
        key: (e) => e.evtDate.month,
        value: (e) => absences
            .where((event) => e.evtDate.month == event.evtDate.month)
            .toList());

    int numberOfAbsences = 0;
    int numberOfUscite = 0;
    int numberOfRitardi = 0;

    absences.forEach((absence) {
      if (absence.evtCode == RegistroConstants.ASSENZA) numberOfAbsences++;
      if (absence.evtCode == RegistroConstants.RITARDO ||
          absence.evtCode == RegistroConstants.RITARDO_BREVE) numberOfRitardi++;
      if (absence.evtCode == RegistroConstants.USCITA) numberOfUscite++;
    });

    final trans = AppLocalizations.of(context);
    return Card(
      margin: EdgeInsets.zero,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildStatsCircle(
                    trans.translate('absences'),
                    numberOfAbsences,
                    Colors.red,
                    true,
                    numberOfUscite / 50,
                  ),
                  _buildStatsCircle(trans.translate('early_exits'),
                      numberOfUscite, Colors.yellow[700], false, 1.0),
                  _buildStatsCircle(trans.translate('delay'), numberOfRitardi,
                      Colors.blue, false, 1.0)
                ],
              ),
            ),
          ),
          AbsencesChartLines(
            absences: absencesMonthMap,
          )
        ],
      ),
    );
  }

  Widget _buildStatsCircle(String typeOfEvent, int numberOfEvent, Color color,
      bool withAnimation, double percent) {
    return Column(
      children: <Widget>[
        CircularPercentIndicator(
          radius: 65.0,
          lineWidth: 6.0,
          percent: percent,
          animation: withAnimation,
          animationDuration: 300,
          center: Text(
            numberOfEvent.toString(),
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          progressColor: color,
        ),
        Text(typeOfEvent)
      ],
    );
  }

  /// The list of absences that are not justified
  Widget _buildNotJustifiedAbsences(Map<Absence, int> absences) {
    final notJustifiedAbsences = new Map.fromIterable(
        absences.keys.where((absence) => absence.isJustified == false),
        key: (k) => k,
        value: (k) => absences[k]);
    if (notJustifiedAbsences.values.length > 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child:
                Text(AppLocalizations.of(context).translate('not_justified')),
          ),
          IgnorePointer(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: notJustifiedAbsences.keys.length,
              itemBuilder: (ctx, index) {
                final absence = notJustifiedAbsences.keys.elementAt(index);
                final days = notJustifiedAbsences[absence];
                return Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: AbsenceCard(
                    absence: absence,
                    days: days,
                  ),
                );
              },
            ),
          )
        ],
      );
    }
    return Container();
  }

  Widget _buildJustifiedAbsences(
      Map<Absence, int> absences, BuildContext context) {
    final justifiedAbsences = new Map.fromIterable(
        absences.keys.where((absence) => absence.isJustified == true),
        key: (k) => k,
        value: (k) => absences[k]);

    if (justifiedAbsences.values.length > 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(AppLocalizations.of(context).translate('justified')),
          ),
          IgnorePointer(
            child: ListView.builder(
              itemCount: justifiedAbsences.keys.length,
              shrinkWrap: true,
              itemBuilder: (ctx, index) {
                final absence = justifiedAbsences.keys.elementAt(index);
                final days = justifiedAbsences[absence];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: AbsenceCard(
                    absence: absence,
                    days: days,
                  ),
                );
              },
            ),
          )
        ],
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 32.0),
        child: CustomPlaceHolder(
          text: 'No absences',
          icon: Icons.assessment,
          onTap: () {
            BlocProvider.of<AbsencesBloc>(context).add(FetchAbsences());
            BlocProvider.of<AbsencesBloc>(context).add(GetAbsences());
          },
          showUpdate: true,
        ),
      ),
    );
  }

  Map<Absence, int> getAbsencesMap(List<Absence> absences) {
    Map<Absence, int> map = new Map();
    Absence start;
    int days = 1;
    if (absences.length == 1) {
      map[absences[0]] = 1;
      return map;
    }

    DateTime current = DateTime.now();
    DateTime next = DateTime.now();

    for (int i = 0; i < absences.length; i++) {
      if (start == null) {
        start = absences[i];
        days = 1;
      }

      double delta = 0;

      if (absences.length > i + 1) {
        current = absences[i].evtDate;
        next = absences[i + 1].evtDate;

        delta = (next.millisecondsSinceEpoch - current.millisecondsSinceEpoch) /
            3600000;
      }

      if (absences[i].evtCode != RegistroConstants.ASSENZA) {
        map[start] = days;
        start = null;
      } else if (delta > 72) {
        map[start] = days;
        start = null;
      } else if (delta == -72) {
        if (current.weekday == DateTime.monday &&
            next.weekday == DateTime.friday) {
          days++;
        } else {
          map[start] = days;
          start = null;
        }
      } else if (delta == -48) {
        if (current.weekday == DateTime.monday &&
            next.weekday == DateTime.saturday) {
          days++;
        } else {
          map[start] = days;
          start = null;
        }
      } else if (delta == -24) {
        days++;
      } else {
        map[start] = days;
        start = null;
      }
    }

    return map;
  }

  Future _updateAbsences() async {
    BlocProvider.of<AbsencesBloc>(context).add(FetchAbsences());
    BlocProvider.of<AbsencesBloc>(context).add(GetAbsences());
  }

  @override
  bool get wantKeepAlive => true;
}
