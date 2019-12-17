import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/subjects/bloc.dart';
import 'package:registro_elettronico/ui/feature/widgets/app_drawer.dart';
import 'package:registro_elettronico/ui/feature/widgets/custom_app_bar.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/constants/drawer_constants.dart';

import 'components/subjects_list.dart';

class LessonsPage extends StatefulWidget {
  const LessonsPage({Key key}) : super(key: key);

  @override
  _LessonsPageState createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer: AppDrawer(
        profileDao: Injector.appInstance.getDependency(),
        position: DrawerConstants.LESSONS,
      ),
      appBar: CustomAppBar(
        title: AppLocalizations.of(context).translate('lessons'),
        scaffoldKey: _drawerKey,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 12.0),
        child: _buildSubjectsList(context),
      ),
    );
  }

  StreamBuilder _buildSubjectsList(BuildContext context) {
    return StreamBuilder(
      stream: BlocProvider.of<SubjectsBloc>(context).subjects,
      initialData: List<Subject>(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final List<Subject> subjects = snapshot.data ?? List<Subject>();
        return StreamBuilder(
            stream: BlocProvider.of<SubjectsBloc>(context).professors,
            initialData: List<Professor>(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              final List<Professor> professors =
                  snapshot.data ?? List<Professor>();
              return SubjectsList(
                professors: professors,
                subjects: subjects,
              );
            });
      },
    );
  }
}
