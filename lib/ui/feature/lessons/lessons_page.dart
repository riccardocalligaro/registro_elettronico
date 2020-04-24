import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:registro_elettronico/component/navigator.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/lessons/bloc.dart';
import 'package:registro_elettronico/ui/bloc/subjects/bloc.dart';
import 'package:registro_elettronico/ui/feature/widgets/cusotm_placeholder.dart';
import 'package:registro_elettronico/ui/feature/widgets/custom_refresher.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/global_utils.dart';
import 'package:registro_elettronico/utils/string_utils.dart';

import 'lesson_details.dart';

class LessonsPage extends StatefulWidget {
  const LessonsPage({Key key}) : super(key: key);

  @override
  _LessonsPageState createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
  List<bool> _refreshed = [false, false];
  RefreshController _refreshController;

  @override
  void initState() {
    BlocProvider.of<SubjectsBloc>(context).add(GetSubjectsAndProfessors());
    _refreshController = RefreshController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

    return Scaffold(
      key: _drawerKey,
      appBar: AppBar(
        brightness: Theme.of(context).brightness,
        title: Text(
          AppLocalizations.of(context).translate('lessons'),
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<SubjectsBloc, SubjectsState>(
            listener: (context, state) {
              if (state is SubjectsUpdateLoadNotConnected) {
                Scaffold.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(
                      AppNavigator.instance.getNetworkErrorSnackBar(context));

                BlocProvider.of<SubjectsBloc>(context)
                    .add(GetSubjectsAndProfessors());

                _refreshController.refreshFailed();
              } else if (state is SubjectsUpdateLoadError) {
                Scaffold.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(
                    AppNavigator.instance.getFloatingSnackBar(
                        AppLocalizations.of(context)
                            .translate('update_error_snackbar')),
                  );

                BlocProvider.of<SubjectsBloc>(context)
                    .add(GetSubjectsAndProfessors());

                _refreshController.refreshFailed();
              } else if (state is SubjectsUpdateLoadSuccess) {
                BlocProvider.of<SubjectsBloc>(context)
                    .add(GetSubjectsAndProfessors());

                _refreshController.refreshCompleted();
              }
            },
          ),
          BlocListener<LessonsBloc, LessonsState>(
            listener: (context, state) {
              if (state is LessonsLoadErrorNotConnected) {
                Scaffold.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(
                      AppNavigator.instance.getNetworkErrorSnackBar(context));

                _refreshController.refreshFailed();
              } else if (state is LessonsLoadServerError ||
                  state is LessonsLoadError) {
                _refreshController.refreshFailed();
              }
            },
          ),
        ],
        child: Container(child: BlocBuilder<SubjectsBloc, SubjectsState>(
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
                  BlocProvider.of<SubjectsBloc>(context).add(UpdateSubjects());
                },
              );
            }
            return Container();
          },
        )),
      ),
    );
  }

  Widget _buildSubjectsList({
    @required List<Subject> subjects,
    @required List<Professor> professors,
    @required BuildContext context,
  }) {
    if (subjects.length > 0) {
      return CustomRefresher(
        controller: _refreshController,
        onRefresh: () async {
          BlocProvider.of<LessonsBloc>(context).add(UpdateAllLessons());
          BlocProvider.of<SubjectsBloc>(context).add(UpdateSubjects());
        },
        child: ListView.builder(
          itemCount: subjects.length,
          itemBuilder: (context, index) {
            final subject = subjects[index];
            final professorsForSubject = professors
                .where((prof) => prof.subjectId == subject.id)
                .toList();
            String professorsText = "";

            professorsForSubject.forEach((prof) {
              String name = StringUtils.titleCase(prof.name);
              if (!professorsText.contains(name)) {
                professorsText += "${StringUtils.titleCase(prof.name)}, ";
              }
            });
            professorsText = StringUtils.removeLastChar(professorsText);
            return Column(
              children: <Widget>[
                ListTile(
                  title: Text(subject.name),
                  subtitle: Text(professorsText),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LessonDetails(
                          subjectId: subject.id,
                          subjectName: _getReducedName(subject.name),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
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

  String _getReducedName(String name) {
    return name.length > 20 ? GlobalUtils.reduceSubjectTitle(name) : name;
  }
}
