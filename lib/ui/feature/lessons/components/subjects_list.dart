import 'package:flutter/material.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/feature/lessons/lesson_details.dart';
import 'package:registro_elettronico/utils/global_utils.dart';
import 'package:registro_elettronico/utils/string_utils.dart';

class SubjectsList extends StatelessWidget {
  final List<Subject> subjects;
  final List<Professor> professors;

  const SubjectsList({Key key, this.subjects, this.professors})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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

          return Material(
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LessonDetails(
                              subjectId: subject.id,
                              subjectName: _getReducedName(subject.name),
                            )));
              },
              child: Container(
                  padding: EdgeInsets.fromLTRB(8.0, 8.0, 16.0, 8.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: ClipOval(
                              child: Container(
                                  width: 60.0,
                                  height: 60.0,
                                  padding: EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: GlobalUtils.getIconFromSubject(
                                      subject.name)),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    _getReducedName(subject.name),
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    // todo: fix overflow
                                    professorsText,
                                    style: TextStyle(),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
          );
        },
      ),
    );
  }

  String _getReducedName(String name) {
    return name.length > 20 ? GlobalUtils.reduceSubjectTitle(name) : name;
  }
}
