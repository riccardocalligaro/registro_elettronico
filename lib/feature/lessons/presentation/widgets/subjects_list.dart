import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/presentation/widgets/custom_refresher.dart';
import 'package:registro_elettronico/feature/lessons/presentation/bloc/lessons_bloc.dart';
import 'package:registro_elettronico/feature/lessons/presentation/lesson_details.dart';
import 'package:registro_elettronico/feature/subjects/presentation/bloc/subjects_bloc.dart';

import 'package:registro_elettronico/utils/global_utils.dart';
import 'package:registro_elettronico/utils/string_utils.dart';

class SubjectsList extends StatelessWidget {
  final List<Subject> subjects;
  final List<Professor> professors;

  const SubjectsList({Key key, this.subjects, this.professors})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    RefreshController _refreshController = RefreshController();
    return CustomRefresher(
      controller: _refreshController,
      onRefresh: () async {
        BlocProvider.of<LessonsBloc>(context).add(UpdateAllLessons());
        BlocProvider.of<SubjectsBloc>(context).add(UpdateSubjects());
        BlocProvider.of<SubjectsBloc>(context).add(GetSubjectsAndProfessors());

        _refreshController.refreshCompleted();
      },
      child: ListView.builder(
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          final subject = subjects[index];
          final professorsForSubject =
              professors.where((prof) => prof.subjectId == subject.id).toList();
          String professorsText = "";
          // professorsText +=
          //     "${StringUtils.titleCase(GlobalUtils.getMockupName(index: index))}, ";
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
  }

  String _getReducedName(String name) {
    return name.length > 20 ? GlobalUtils.reduceSubjectTitle(name) : name;
  }
}
