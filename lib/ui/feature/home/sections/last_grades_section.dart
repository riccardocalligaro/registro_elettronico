import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
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
    return BlocBuilder<GradesBloc, GradesState>(
      builder: (context, state) {
        if (state is GradesUpdateLoading) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 100.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is GradesLoaded) {
          return _buildLastGradesList(state.grades);
        } else if (state is GradesError || state is GradesUpdateError) {
          return CustomPlaceHolder(
            icon: Icons.error,
            text: AppLocalizations.of(context).translate('error'),
            showUpdate: true,
            onTap: () {
              BlocProvider.of<GradesBloc>(context).add(UpdateGrades());
              BlocProvider.of<GradesBloc>(context).add(GetGrades());
            },
          );
        }
        return Container();
      },
    );
  }

  Widget _buildLastGradesList(List<Grade> grades) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 6.0),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: grades.length,
      itemBuilder: (context, index) {
        return _buildListViewCard(grades[index], context);
      },
    );
  }

  Widget _buildListViewCard(Grade grade, BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: GlobalUtils.getColorFromGrade(grade),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Column(
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
                )
              ],
            ),
            Text(
              grade.displayValue,
              style: TextStyle(fontSize: 18),
            )
          ],
        ),
      ),
    );
  }
}
