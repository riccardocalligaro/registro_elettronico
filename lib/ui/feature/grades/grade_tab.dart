import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/grades/grades_bloc.dart';

class GradeTab extends StatefulWidget {
  final int period;

  const GradeTab({Key key, @required this.period}) : super(key: key);

  @override
  _GradeTabState createState() => _GradeTabState();
}

class _GradeTabState extends State<GradeTab> {
  GradesBloc _gradesBloc;
  Stream<List<Grade>> _stream;

  @override
  void initState() {
    _gradesBloc = BlocProvider.of<GradesBloc>(context);
    _stream = _gradesBloc.watchAllGrades();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: StreamBuilder(
        stream: _stream,
        initialData: List<Grade>(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          final List<Grade> grades = snapshot.data ?? List<Grade>();
          // final gradesOfPeriod = grades
          //     .where((grade) => grade.periodPos == periods[index].position)
          //     .toList();
          return Text(grades.toString());
          // return Text('ocp');
          //return GradesSection(
          //    grades: index > periods.length + 1 ? gradesOfPeriod : grades);
        },
      ),
    );
  }
}
