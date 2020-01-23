import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/lessons/bloc.dart';
import 'package:registro_elettronico/ui/feature/lessons/lesson_details.dart';
import 'package:registro_elettronico/ui/feature/widgets/custom_refresher.dart';
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
        _refreshController.refreshCompleted();
      },
      child: ListView.builder(
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          final subject = subjects[index];
          final professorsForSubject =
              professors.where((prof) => prof.subjectId == subject.id).toList();
          String professorsText = "";
          professorsForSubject.forEach((prof) {
            String name = StringUtils.titleCase(prof.name);
            if (!professorsText.contains(name))
              professorsText += "${StringUtils.titleCase(prof.name)}, ";
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
