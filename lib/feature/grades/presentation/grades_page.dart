import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/feature/grades/presentation/states/grades_failure.dart';
import 'package:registro_elettronico/feature/grades/presentation/states/grades_loaded.dart';
import 'package:registro_elettronico/feature/grades/presentation/updater/grades_updater_bloc.dart';
import 'package:registro_elettronico/feature/grades/presentation/watcher/grades_watcher_bloc.dart';

class GradesPage extends StatefulWidget {
  GradesPage({Key key}) : super(key: key);

  @override
  _GradesPageState createState() => _GradesPageState();
}

class _GradesPageState extends State<GradesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate('grades'),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              BlocProvider.of<GradesUpdaterBloc>(context).add(UpdateGrades());
            },
          )
        ],
      ),
      body: BlocBuilder<GradesWatcherBloc, GradesWatcherState>(
        builder: (context, state) {
          if (state is GradesWatcherLoadSuccess) {
            return GradesLoaded(sections: state.gradesSections);
          } else if (state is GradesWatcherFailure) {
            return GradesFailure(failure: state.failure);
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
