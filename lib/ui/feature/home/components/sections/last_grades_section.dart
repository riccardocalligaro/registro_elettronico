import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/grades/bloc.dart';
import 'package:registro_elettronico/ui/feature/widgets/cusotm_placeholder.dart';
import 'package:registro_elettronico/ui/feature/widgets/grade_card.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';

class LastGradesSection extends StatelessWidget {
  const LastGradesSection({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: _buildLastGrades(context),
    );
  }

  Widget _buildLastGrades(BuildContext context) {
    return BlocBuilder<GradesBloc, GradesState>(
      builder: (context, state) {
        if (state is GradesUpdateLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is GradesLoaded) {
          return _buildLastGradesList(state.grades, context);
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

        return Text(state.toString());
      },
    );
  }

  Widget _buildLastGradesList(List<Grade> grades, BuildContext context) {
    if (grades.length > 0) {
      return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(0),
        shrinkWrap: true,
        itemCount: grades.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: GradeCard(
              grade: grades[index],
            ),
          );
        },
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Icon(
                Icons.timeline,
                size: 64,
              ),
              SizedBox(
                height: 10,
              ),
              Text(AppLocalizations.of(context).translate('no_grades'))
            ],
          ),
        ),
      );
    }
  }
}
