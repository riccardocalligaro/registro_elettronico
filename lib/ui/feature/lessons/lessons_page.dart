import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/subjects/bloc.dart';
import 'package:registro_elettronico/ui/feature/widgets/app_drawer.dart';
import 'package:registro_elettronico/ui/feature/widgets/cusotm_placeholder.dart';
import 'package:registro_elettronico/ui/feature/widgets/custom_app_bar.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/constants/drawer_constants.dart';

import 'components/subjects_list.dart';

class LessonsPage extends StatelessWidget {
  const LessonsPage({Key key}) : super(key: key);

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
      body: LessonsPageContent(),
    );
  }
}

class LessonsPageContent extends StatefulWidget {
  const LessonsPageContent({Key key}) : super(key: key);

  @override
  _LessonsPageContentState createState() => _LessonsPageContentState();
}

class _LessonsPageContentState extends State<LessonsPageContent> {
  @override
  void didChangeDependencies() {

    BlocProvider.of<SubjectsBloc>(context).add(GetSubjectsAndProfessors());

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubjectsBloc, SubjectsState>(
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
              BlocProvider.of<SubjectsBloc>(context).add(UpdateSubjects());
            },
          );
        }
        return Container();
      },
    );
  }

  Widget _buildSubjectsList({
    @required List<Subject> subjects,
    @required List<Professor> professors,
    @required BuildContext context,
  }) {
    if (subjects.length > 0) {
      return RefreshIndicator(
        onRefresh: () {
          return _refreshSubjects(context);
        },
        child: SubjectsList(
          professors: professors,
          subjects: subjects,
        ),
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

  Future _refreshSubjects(BuildContext context) {
    BlocProvider.of<SubjectsBloc>(context).add(UpdateSubjects());
    BlocProvider.of<SubjectsBloc>(context).add(GetSubjectsAndProfessors());
  }
}
