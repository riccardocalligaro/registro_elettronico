import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/lessons/lessons_bloc.dart';

class LessonDetails extends StatelessWidget {
  final int subjectId;
  final String subjectName;

  const LessonDetails(
      {Key key, @required this.subjectId, @required this.subjectName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text(
            subjectName,
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: _buildLessonsList(context),
        ));
  }

  StreamBuilder<List<Lesson>> _buildLessonsList(BuildContext context) {
    return StreamBuilder(
      stream: BlocProvider.of<LessonsBloc>(context).relevantLessons,
      initialData: List<Lesson>(),
      builder: (BuildContext context, AsyncSnapshot<List<Lesson>> snapshot) {
        final List<Lesson> subjects = snapshot.data
                .where((lesson) => lesson.subjectId == subjectId)
                .toList() ??
            List<Lesson>();
        return ListView.builder(
          itemCount: subjects.length,
          itemBuilder: (context, index) {
            final subject = subjects[index];
            return Padding(
              padding: const EdgeInsets.only(top: 12.0),
              // todo: add case if there is no lesson argument
              child: Card(
                  child: ListTile(
                title: Text(subject.lessonArg != "" ? subject.lessonArg : "No  description."),
                subtitle: Text(subject.lessonType),
              )),
            );
          },
        );
      },
    );
  }
}
