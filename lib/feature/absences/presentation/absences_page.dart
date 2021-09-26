import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/core/infrastructure/navigator.dart';

import 'absences_list.dart';
import 'bloc/absences_bloc.dart';

class AbsencesPage extends StatefulWidget {
  const AbsencesPage({Key? key}) : super(key: key);

  @override
  _AbsencesPageState createState() => _AbsencesPageState();
}

class _AbsencesPageState extends State<AbsencesPage> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<AbsencesBloc>(context).add(GetAbsences());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Theme.of(context).brightness,
        title: Text(AppLocalizations.of(context)!.translate('absences')!),
      ),
      body: BlocListener<AbsencesBloc, AbsencesState>(
        listener: (context, state) {
          if (state is AbsencesLoadErrorNotConnected) {
            ScaffoldMessenger.of(context).showSnackBar(
              AppNavigator.instance!.getNetworkErrorSnackBar(context),
            );
          }
        },
        child: AbsencesList(),
      ),
    );
  }
}
