import 'package:flutter/material.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';

class GradesSection extends StatelessWidget {
  // Grades
  final List<Grade> grades;

  const GradesSection({Key key, @required this.grades}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (grades.length > 0) {
      return Container(
        child: Column(),
      );
    }
    return Center(
      child: Text('No grades 😐'),
    );
  }
}
