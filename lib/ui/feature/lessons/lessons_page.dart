import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/subjects/bloc.dart';
import 'package:registro_elettronico/ui/feature/lessons/subjects_list.dart';

class LessonsPage extends StatelessWidget {
  const LessonsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
   
      child: _buildSubjectsList(context),
    );
    return Container(
      child: Container(
        height: 70,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: ClipOval(
                child: Container(
                  height: 55,
                  width: 55,
                  color: Colors.white,
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
                  child: Text('aa',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 20)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Text',
                    style: TextStyle(),
                  ),
                  Text(
                    'Text',
                    style: TextStyle(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildSubjectsList(BuildContext context) {
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
              print(professors[0]);
              return SubjectsList(
                professors: professors,
                subjects: subjects,
              );
            });
      },
    );
  }
}
