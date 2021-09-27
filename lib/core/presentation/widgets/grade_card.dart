import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/feature/grades/domain/model/grade_domain_model.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:registro_elettronico/utils/global_utils.dart';

class GradeCard extends StatelessWidget {
  final GradeDomainModel grade;
  final bool fromSubjectGrades;

  const GradeCard({
    Key? key,
    required this.grade,
    this.fromSubjectGrades = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: GlobalUtils.getColorFromGrade(grade),
      ),
      child: Material(
        child: InkWell(
          borderRadius: BorderRadius.all(
            Radius.circular(4.0),
          ),
          onTap: () {
            _showGradeInfoDialog(context);
          },
          onLongPress: () {
            if (!fromSubjectGrades) {
              _showDeleteGradeDialog(context);
            }
          },
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  ClipOval(
                    child: Container(
                      height: 55,
                      width: 55,
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 15.0),
                      child: AutoSizeText(
                        grade.displayValue!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          AutoSizeText(
                            grade.subjectDesc!.length > 20
                                ? GlobalUtils.reduceSubjectTitle(
                                        grade.subjectDesc!) ??
                                    ''
                                : grade.subjectDesc!,
                            style: TextStyle(color: Colors.white),
                            maxLines: 1,
                          ),
                          _buildLessonArgument(grade),
                          AutoSizeText(
                            SRDateUtils.convertDateLocale(
                                grade.eventDate,
                                AppLocalizations.of(context)!
                                    .locale
                                    .toString()),
                            style: TextStyle(color: Colors.white),
                            maxLines: 1,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        color: Colors.transparent,
      ),
    );
  }

  void _showGradeInfoDialog(BuildContext context) {
    final trans = AppLocalizations.of(context);
    String valueRow;
    if (grade.localllyCancelled!) {
      valueRow = 'Valore: ${grade.decimalValue} (voto cancellato localmente)';
    } else if (grade.cancelled!) {
      valueRow = 'Valore: voto cancellato';
    } else if (grade.decimalValue == -1) {
      valueRow = 'Valore che non fa media (voto in blu): ${grade.displayValue}';
    } else {
      valueRow =
          '${trans!.translate('decimal_value')}: ${grade.decimalValue.toString()}';
    }
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "${trans!.translate('notes')}: ${grade.notesForFamily!.isNotEmpty ? grade.notesForFamily : trans.translate('not_presents')!.toLowerCase()}",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  valueRow,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  '${trans.translate('date')}: ${SRDateUtils.convertDateLocale(grade.eventDate, trans.locale.toString())}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  '${trans.translate('term')}: ${grade.periodDesc!.toLowerCase()}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _showDeleteGradeDialog(BuildContext context) {
    if (grade.decimalValue != -1.00 && grade.cancelled == false) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(grade.localllyCancelled!
              ? AppLocalizations.of(context)!
                  .translate('delete_grade_title_restore')!
              : AppLocalizations.of(context)!
                  .translate('delete_grade_title_cancel')!),
          //content: Text(grades[index].localllyCancelled.toString()),
          actions: <Widget>[
            TextButton(
              child: Text(
                AppLocalizations.of(context)!.translate('no')!.toUpperCase(),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)!
                  .translate('yes')!
                  .toUpperCase()),
              onPressed: () async {
                Navigator.pop(context);
              },
            )
          ],
        ),
      );
    }
  }

  Widget _buildLessonArgument(GradeDomainModel grade) {
    String text = grade.notesForFamily!;
    if (text.isNotEmpty) {
      if (text.length > 30) {
        text = text.substring(0, 30);
        text += "...";
      }
      return AutoSizeText(
        text,
        style: TextStyle(color: Colors.white),
        overflow: TextOverflow.ellipsis,
      );
    }
    return Container();
  }
}
