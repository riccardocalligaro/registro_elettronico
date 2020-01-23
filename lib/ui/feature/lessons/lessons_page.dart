import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/lessons/bloc.dart';
import 'package:registro_elettronico/ui/bloc/subjects/bloc.dart';
import 'package:registro_elettronico/ui/feature/widgets/app_drawer.dart';
import 'package:registro_elettronico/ui/feature/widgets/cusotm_placeholder.dart';
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
  @override
  void initState() {
    BlocProvider.of<SubjectsBloc>(context).add(GetSubjectsAndProfessors());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

    return Scaffold(
      key: _drawerKey,
      drawer: AppDrawer(
        position: DrawerConstants.LESSONS,
      ),
      appBar: CustomAppBar(
        title: Text(AppLocalizations.of(context).translate('lessons')),
        scaffoldKey: _drawerKey,
      ),
      body: BlocListener<LessonsBloc, LessonsState>(
        listener: (context, state) {
          if (state is LessonsUpdateLoadInProgress) {
            Scaffold.of(context).showSnackBar(SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(AppLocalizations.of(context)
                      .translate('updating_lessons')),
                  Container(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.red,
                    ),
                  )
                ],
              ),
              duration: Duration(minutes: 2),
            ));
          }
          if (state is LessonsUpdateLoadSuccess) {
            Scaffold.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text(
                    AppLocalizations.of(context).translate('lessons_updated')),
              ));
          }
        },
        child: Container(
          // onWillPop: () {
          //    AppNavigator.instance.navToHome(context);
          //    return 
          // },
          //snackBar: AppNavigator.instance.getLeaveSnackBar(context),
          child: BlocBuilder<SubjectsBloc, SubjectsState>(
            builder: (context, state) {
              if (state is SubjectsAndProfessorsLoadInProgress) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is SubjectsAndProfessorsLoadSuccess) {
                return _buildSubjectsList(
                  subjects: state.subjects,
                  professors: state.professors,
                  context: context,
                );
              } else if (state is SubjectsUpdateLoadError ||
                  state is SubjectsLoadError) {
                return CustomPlaceHolder(
                  text: AppLocalizations.of(context).translate('error'),
                  icon: Icons.error,
                  showUpdate: true,
                  onTap: () {
                    BlocProvider.of<SubjectsBloc>(context)
                        .add(UpdateSubjects());
                  },
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectsList({
    @required List<Subject> subjects,
    @required List<Professor> professors,
    @required BuildContext context,
  }) {
    if (subjects.length > 0) {
      return SubjectsList(
        professors: professors,
        subjects: subjects,
      );
    } else {
      return CustomPlaceHolder(
        text: AppLocalizations.of(context).translate('no_subjects_to_show'),
        icon: Icons.assignment,
        onTap: () {
          BlocProvider.of<SubjectsBloc>(context).add(UpdateSubjects());
          BlocProvider.of<SubjectsBloc>(context)
              .add(GetSubjectsAndProfessors());
        },
        showUpdate: true,
      );
    }
  }
}
