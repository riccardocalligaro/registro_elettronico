import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/subjects/bloc.dart';
import 'package:registro_elettronico/ui/feature/lessons/subjects_list.dart';

class LessonsPage extends StatefulWidget {
  const LessonsPage({Key key}) : super(key: key);

  @override
  _LessonsPageState createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildSubjectsList(context),
    );
  }

  StreamBuilder _buildSubjectsList(BuildContext context) {
    return StreamBuilder(
      stream: BlocProvider.of<SubjectsBloc>(context).subjects,
      initialData: List<Subject>(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final List<Subject> subjects = snapshot.data ?? List<Subject>();
        return StreamBuilder(
            stream: BlocProvider.of<SubjectsBloc>(context).professors,
            initialData: List<Professor>(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              final List<Professor> professors =
                  snapshot.data ?? List<Professor>();
              return SubjectsList(
                professors: professors,
                subjects: subjects,
              );
            });
      },
    );
  }
}
