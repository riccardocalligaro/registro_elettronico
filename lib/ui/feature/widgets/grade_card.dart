import 'package:flutter/material.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:registro_elettronico/utils/global_utils.dart';

class GradeCard extends StatelessWidget {
  final Grade grade;

  const GradeCard({Key key, this.grade}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: GlobalUtils.getColorFromGrade(grade)),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          ClipOval(
            child: Container(
              height: 55,
              width: 55,
              color: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
              child: Text(grade.displayValue,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 20)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  //grade.localllyCancelled.toString(),
                  grade.subjectDesc.length > 20
                      ? GlobalUtils.reduceSubjectTitle(grade.subjectDesc)
                      : grade.subjectDesc,
                  style: TextStyle(color: Colors.white),
                ),
                _buildLessonArgument(grade),
                Text(
                  DateUtils.convertDateLocale(grade.eventDate,
                      AppLocalizations.of(context).locale.toString()),
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLessonArgument(Grade grade) {
    String text = grade.notesForFamily;
    if (text.length > 0) {
      if (text.length > 30) {
        text = text.substring(0, 30);
        text += "...";
      }
      return Text(
        text,
        style: TextStyle(color: Colors.white),
      );
    }
    return Container();
  }
}
