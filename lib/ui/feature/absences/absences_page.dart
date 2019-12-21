import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/absences/absences_bloc.dart';
import 'package:registro_elettronico/ui/bloc/absences/absences_event.dart';
import 'package:registro_elettronico/ui/bloc/agenda/agenda_bloc.dart';
import 'package:registro_elettronico/ui/feature/absences/components/absence_card.dart';
import 'package:registro_elettronico/ui/feature/widgets/app_drawer.dart';
import 'package:registro_elettronico/ui/feature/widgets/custom_app_bar.dart';
import 'package:registro_elettronico/ui/feature/widgets/section_header.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/constants/drawer_constants.dart';
import 'package:registro_elettronico/utils/constants/registro_constants.dart';
import 'package:registro_elettronico/utils/date_utils.dart';

class AbsencesPage extends StatelessWidget {
  const AbsencesPage({Key key}) : super(key: key);

  /// ABA0 assenza
  /// ABU0 uscita
  /// ABR0 ritardo
  /// ABR1 ritardo breve
  /// ABU0 uscita anticipata
  /// A ---- Health reasons
  /// AC --- Health reasons + medical certificate
  /// B ---- Family reasons
  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

    return Scaffold(
      key: _drawerKey,
      appBar: CustomAppBar(
        scaffoldKey: _drawerKey,
        title: AppLocalizations.of(context).translate('absences'),
      ),
      drawer: AppDrawer(
        profileDao: Injector.appInstance.getDependency(),
        position: DrawerConstants.ABSENCES,
      ),
      body: SingleChildScrollView(
        child: _buildAbsences(context),
      ),
    );
  }

  Widget _buildAbsences(BuildContext context) {
    return StreamBuilder(
      stream: BlocProvider.of<AbsencesBloc>(context).watchAgenda(),
      initialData: List<Absence>(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final List<Absence> absences = snapshot.data ?? List<Absence>();
        final map = getAbsencesMap(
            absences..sort((b, a) => a.evtDate.compareTo(b.evtDate)));
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              _buildNotJustifiedAbsences(map),
              Text('Justified'),
              _buildJustifiedAbsences(map),
              RaisedButton(
                child: Text('update'),
                onPressed: () {
                  BlocProvider.of<AbsencesBloc>(context).add(FetchAbsences());
                },
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotJustifiedAbsences(Map<Absence, int> absences) {
    final notJustifiedAbsences = new Map.fromIterable(
        absences.keys.where((absence) => absence.isJustified == false),
        key: (k) => k,
        value: (k) => absences[k]);

    return IgnorePointer(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: notJustifiedAbsences.keys.length,
        itemBuilder: (ctx, index) {
          final absence = notJustifiedAbsences.keys.elementAt(index);
          final days = notJustifiedAbsences[absence];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: AbsenceCard(
              absence: absence,
              days: days,
            ),
          );
        },
      ),
    );
  }

  Widget _buildJustifiedAbsences(Map<Absence, int> absences) {
    final justifiedAbsences = new Map.fromIterable(
        absences.keys.where((absence) => absence.isJustified == true),
        key: (k) => k,
        value: (k) => absences[k]);

    return IgnorePointer(
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

      print(days);
      if (delta > 72) {
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
}
