import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/feature/grades/domain/model/grade_domain_model.dart';
import 'package:registro_elettronico/feature/grades/presentation/operations/grades_operations_bloc.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:registro_elettronico/utils/global_utils.dart';

class SRGradeCard extends StatelessWidget {
  final GradeDomainModel grade;

  const SRGradeCard({
    Key? key,
    required this.grade,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: Material(
        borderRadius: BorderRadius.circular(4.0),
        color: GlobalUtils.getColorFromGrade(grade),
        child: InkWell(
          borderRadius: const BorderRadius.all(
            Radius.circular(4.0),
          ),
          onTap: () {
            _showGradeInfoDialog(context);
          },
          onLongPress: () {
            _showDeleteGradeDialog(context);
          },
          child: Row(
            children: [
              const SizedBox(
                width: 12,
              ),
              ClipOval(
                child: Container(
                  height: 60,
                  width: 60,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 19.0,
                  ),
                  child: Text(
                    grade.displayValue!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 21,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildGradeTitle(grade),
                  _buildLessonArgument(grade),
                  Text(
                    SRDateUtils.convertDateLocale(
                      grade.eventDate,
                      AppLocalizations.of(context)!.locale.toString(),
                    ),
                    style: const TextStyle(color: Colors.white),
                    maxLines: 1,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGradeTitle(GradeDomainModel grade) {
    final subjectName = grade.subjectDesc!.length > 20
        ? GlobalUtils.reduceSubjectTitle(grade.subjectDesc!)
        : grade.subjectDesc;

    String text = '$subjectName - ${grade.componentDesc}';
    if (text.isNotEmpty) {
      if (text.length > 35) {
        text = text.substring(0, 35);
        text += "...";
      }
      return Text(
        text,
        style: TextStyle(color: Colors.white),
        overflow: TextOverflow.ellipsis,
      );
    }

    return Text(text);
  }

  Widget _buildLessonArgument(GradeDomainModel grade) {
    String text = grade.notesForFamily!;
    if (text.isNotEmpty) {
      if (text.length > 30) {
        text = text.substring(0, 30);
        text += "...";
      }
      return Text(
        text,
        style: TextStyle(color: Colors.white),
        overflow: TextOverflow.ellipsis,
      );
    }
    return Container();
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
                  '${trans.translate('term')}: ${grade.periodPos}° ${grade.periodDesc!.toLowerCase()}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  '${trans.translate('type')}: ${grade.componentDesc}',
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
              child: Text(
                  AppLocalizations.of(context)!.translate('yes')!.toUpperCase()),
              onPressed: () async {
                BlocProvider.of<GradesOperationsBloc>(context).add(
                  ToggleGradeLocallyCancelledState(gradeDomainModel: grade),
                );

                Navigator.pop(context);
              },
            )
          ],
        ),
      );
    }
  }
}
