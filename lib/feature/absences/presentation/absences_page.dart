import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/component/app_injection.dart';
import 'package:registro_elettronico/component/navigator.dart';
import 'package:registro_elettronico/ui/feature/widgets/last_update_bottom_sheet.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'absences_list.dart';
import 'bloc/absences_bloc.dart';

class AbsencesPage extends StatefulWidget {
  const AbsencesPage({Key key}) : super(key: key);

  @override
  _AbsencesPageState createState() => _AbsencesPageState();
}

class _AbsencesPageState extends State<AbsencesPage> {
  int _absencesLastUpdate;

  @override
  void initState() {
    restore();
    super.initState();

    BlocProvider.of<AbsencesBloc>(context).add(GetAbsences());
  }

  void restore() async {
    SharedPreferences sharedPreferences = sl();
    setState(() {
      _absencesLastUpdate =
          sharedPreferences.getInt(PrefsConstants.LAST_UPDATE_ABSENCES);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Theme.of(context).brightness,
        title: Text(AppLocalizations.of(context).translate('absences')),
      ),
      bottomSheet: LastUpdateBottomSheet(
        millisecondsSinceEpoch: _absencesLastUpdate,
      ),
      body: BlocListener<AbsencesBloc, AbsencesState>(
        listener: (context, state) {
          if (state is AbsencesUpdateLoaded) {
            setState(() {
              _absencesLastUpdate = DateTime.now().millisecondsSinceEpoch;
            });
          }
          if (state is AbsencesLoadErrorNotConnected) {
            Scaffold.of(context).showSnackBar(
              AppNavigator.instance.getNetworkErrorSnackBar(context),
            );
          }
        },
        child: AbsencesList(),
      ),
    );
  }
}
