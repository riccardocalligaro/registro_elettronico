import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/data/db/dao/grade_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/grades/bloc.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:registro_elettronico/utils/global_utils.dart';

class GradeCard extends StatelessWidget {
  final Grade grade;

  const GradeCard({Key key, this.grade}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onDoubleTap: () {
        // GradeDao gradeDao = GradeDao(AppDatabase());
        // gradeDao.deleteGrade(grade);
      },
      onTap: () {
        final trans = AppLocalizations.of(context);
        showDialog(
          context: context,
          builder: (context) => SimpleDialog(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "${trans.translate('notes')}: ${grade.notesForFamily.length > 0 ? grade.notesForFamily : trans.translate('not_presents').toLowerCase()}",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      '${trans.translate('decimal_value')}: ${grade.decimalValue == -1.0 ? "🤔" : grade.decimalValue.toString()}'),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                      '${trans.translate('date')}: ${DateUtils.convertDateLocale(grade.eventDate, trans.locale.toString())}'),
                  SizedBox(
                    height: 5,
                  ),
                  Text('${trans.translate('term')}: ${grade.periodPos}'),
                  SizedBox(
                    height: 5,
                  ),
                  Text('${trans.translate('weight')}: ${grade.weightFactor}'),
                ],
              )
            ],
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: grade.cancelled
                ? GlobalUtils.getColorFromAverage(-1)
                : GlobalUtils.getColorFromAverage(grade.decimalValue)),
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            ClipOval(
              child: Container(
                height: 55,
                width: 55,
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
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
      ),
    );
  }

  Widget _buildLessonArgument(Grade grade) {
    String text = grade.notesForFamily;
    if (text.length > 0) {
      if (text.length > 40) {
        text = text.substring(0, 39);
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
