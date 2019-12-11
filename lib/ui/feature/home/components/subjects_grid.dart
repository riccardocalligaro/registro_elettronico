import 'package:flutter/material.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/utils/global_utils.dart';

class SubjectsGrid extends StatelessWidget {
  final List<Subject> subjects;

  const SubjectsGrid({Key key, this.subjects}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: IgnorePointer(
        child: GridView.count(
            crossAxisCount: 4,
            crossAxisSpacing: 0.0,
            mainAxisSpacing: 5.0,
            shrinkWrap: true,
            children: List.generate(subjects.length, (index) {
              final subject = subjects[index];
              return GridTile(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                    ClipOval(
                      child: Container(
                          width: 60.0,
                          height: 60.0,
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(color: Colors.white),
                          child: GlobalUtils.getIconFromSubject(subject.name)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Text(
                        subject.name.length > 14
                            ? GlobalUtils.reduceSubjectGridTitle(subject.name)
                            : subject.name,
                        style: TextStyle(fontSize: 9),
                      ),
                    )
                  ]));
            })),
      ),
    );
  }
}