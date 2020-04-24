import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/dashboard/grades/bloc.dart';
import 'package:registro_elettronico/ui/bloc/grades/bloc.dart';
import 'package:registro_elettronico/ui/bloc/grades/grades_bloc.dart';
import 'package:registro_elettronico/ui/bloc/grades/grades_state.dart';
import 'package:registro_elettronico/ui/feature/widgets/cusotm_placeholder.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:registro_elettronico/utils/global_utils.dart';
import 'package:registro_elettronico/utils/string_utils.dart';

class LastGradesSection extends StatelessWidget {
  const LastGradesSection({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GradesDashboardBloc, GradesDashboardState>(
      builder: (context, state) {
        if (state is GradesDashboardLoadSuccess) {
          return _buildLastGradesList(state.grades, context);
        } else if (state is GradesDashboardLoadError) {
          return CustomPlaceHolder(
            icon: Icons.error,
            text: AppLocalizations.of(context).translate('error'),
            showUpdate: true,
            onTap: () {
              BlocProvider.of<GradesBloc>(context).add(UpdateGrades());
            },
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 100.0),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget _buildLastGradesList(List<Grade> grades, BuildContext context) {
    if (grades.length > 0) {
      return ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 6.0),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: grades.length,
        itemBuilder: (context, index) {
          return _buildListViewCard(grades[index], context);
        },
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: CustomPlaceHolder(
          icon: Icons.timeline,
          text: AppLocalizations.of(context).translate('no_grades'),
          showUpdate: false,
        ),
      );
    }
  }

  Widget _buildListViewCard(Grade grade, BuildContext context) {
    return Card(
      child: ListTile(
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 0, 12),
          child: Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: GlobalUtils.getColorFromGrade(grade),
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                grade.subjectDesc.length > 35
                    ? StringUtils.titleCase(
                        GlobalUtils.reduceSubjectTitleWithLength(
                            grade.subjectDesc, 34))
                    : StringUtils.titleCase(grade.subjectDesc),
                style: TextStyle(fontSize: 15),
              ),
              Text(
                DateUtils.convertDateLocale(grade.eventDate,
                    AppLocalizations.of(context).locale.toString()),
                style: TextStyle(fontSize: 11),
              )
            ],
          ),
        ),
        trailing: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            grade.displayValue,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
    // return Card(
    //   margin: EdgeInsets.symmetric(vertical: 4.0),
    //   child: Padding(
    //     padding: const EdgeInsets.all(16.0),
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: <Widget>[
    //         Row(
    //           children: <Widget>[
    //             Container(
    //               height: 20,
    //               width: 20,
    //               decoration: BoxDecoration(
    //                 shape: BoxShape.circle,
    //                 color: GlobalUtils.getColorFromGrade(grade),
    //               ),
    //             ),
    //             SizedBox(
    //               width: 15,
    //             ),
    //             Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: <Widget>[
    //                 Text(
    //                   grade.subjectDesc.length > 35
    //                       ? StringUtils.titleCase(
    //                           GlobalUtils.reduceSubjectTitleWithLength(
    //                               grade.subjectDesc, 34))
    //                       : StringUtils.titleCase(grade.subjectDesc),
    //                   style: TextStyle(fontSize: 15),
    //                 ),
    //                 Text(
    //                   DateUtils.convertDateLocale(grade.eventDate,
    //                       AppLocalizations.of(context).locale.toString()),
    //                   style: TextStyle(fontSize: 11),
    //                 )
    //               ],
    //             )
    //           ],
    //         ),
    //         Flexible(
    //           child: Text(
    //             grade.displayValue,
    //             style: TextStyle(fontSize: 18),
    //           ),
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }
}
