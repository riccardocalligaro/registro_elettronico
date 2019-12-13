import 'package:flutter/material.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/utils/global_utils.dart';

class GradeCard extends StatelessWidget {
  final Grade grade;

  const GradeCard({Key key, this.grade}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: GlobalUtils.getColorFromGrade(grade.decimalValue)),
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            Text(grade.displayValue,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 21)),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    grade.subjectDesc,
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    GlobalUtils.convertDateForDisplay(grade.eventDate),
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
