import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/component/navigator.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/lessons/bloc.dart';
import 'package:registro_elettronico/ui/bloc/subjects/bloc.dart';
import 'package:registro_elettronico/ui/feature/widgets/cusotm_placeholder.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';

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
      // drawer: AppDrawer(
      //   position: DrawerConstants.LESSONS,
      // ),
      appBar: AppBar(
        brightness: Theme.of(context).brightness,
        title: Text(
          AppLocalizations.of(context).translate('lessons'),
        ),
      ),
      // appBar: CustomAppBar(
      //   title: Text(AppLocalizations.of(context).translate('lessons')),
      //   scaffoldKey: _drawerKey,
      // ),
      body: BlocListener<LessonsBloc, LessonsState>(
        listener: (context, state) {
          if (state is LessonsLoadErrorNotConnected) {
            Scaffold.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(
                  AppNavigator.instance.getNetworkErrorSnackBar(context));
          }
        },
        child: Container(
          child: BlocBuilder<SubjectsBloc, SubjectsState>(
            builder: (context, state) {
              if (state is SubjectsAndProfessorsLoadInProgress ||
                  state is SubjectsUpdateLoadInProgress) {
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
          BlocProvider.of<LessonsBloc>(context).add(UpdateAllLessons());

          BlocProvider.of<SubjectsBloc>(context)
              .add(GetSubjectsAndProfessors());
        },
        showUpdate: true,
      );
    }
  }
}
