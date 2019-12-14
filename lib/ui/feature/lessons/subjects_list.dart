import 'package:flutter/material.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/utils/global_utils.dart';

class SubjectsList extends StatelessWidget {
  final List<Subject> subjects;
  final List<Professor> professors;

  const SubjectsList(
      {Key key, @required this.subjects, @required this.professors})
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
            String name = prof.name.toLowerCase();
            if (!professorsText.contains(name))
              professorsText += "${prof.name.toLowerCase()}, ";
          });

          return Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: ClipOval(
                    child: Container(
                        width: 70.0,
                        height: 70.0,
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: GlobalUtils.getIconFromSubject(subject.name)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        subject.name.length > 20
                            ? GlobalUtils.reduceSubjectTitle(subject.name)
                            : subject.name,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        // todo: fix overflow
                        professorsText,
                        style: TextStyle(),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
