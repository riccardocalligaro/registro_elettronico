import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:registro_elettronico/utils/global_utils.dart';

class LocalGradeCard extends StatelessWidget {
  final LocalGrade localGrade;

  const LocalGradeCard({Key key, @required this.localGrade}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 55,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: GlobalUtils.getColorFromAverage(localGrade.decimalValue)),
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            ClipOval(
              child: Container(
                height: 70,
                width: 40,
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 9.0),
                child: Text(localGrade.displayValue,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 7.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    DateUtils.convertDateLocale(localGrade.eventDate,
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

  //// Widget _buildLessonArgument(Grade grade) {
  ////   String text = grade.notesForFamily;
  ////   if (text.length > 0) {
  ////     if (text.length > 40) {
  ////       text = text.substring(0, 39);
  ////       text += "...";
  ////     }
  ////     return Text(
  ////       text,
  ////       style: TextStyle(color: Colors.white),
  ////     );
  ////   }
  ////   return Container();
  //// }
}
