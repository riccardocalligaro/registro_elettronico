import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/grades/bloc.dart';
import 'package:registro_elettronico/ui/feature/home/components/widgets/subjects_grid.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/global_utils.dart';

class SubjectsGridSection extends StatelessWidget {
  final int period;

  const SubjectsGridSection({Key key, this.period}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<GradesBloc>(context).add(GetGradesAndSubjects());
    return _buildSubjectsBlocBuilder(context);
  }

  BlocBuilder _buildSubjectsBlocBuilder(BuildContext context) {
    return BlocBuilder<GradesBloc, GradesState>(
      builder: (context, state) {
        if (state is GradesAndSubjectsLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is GradesAndSubjectsLoaded) {
          return _buildSubjectsGrid(state.subject, state.grades, context);
        }
        return Container();
      },
    );
  }

  Widget _buildSubjectsGrid(
      List<Subject> subjects, List<Grade> grades, BuildContext context) {
    if (subjects.length == 0) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Icon(
                Icons.assessment,
                size: 64,
              ),
              SizedBox(
                height: 10,
              ),
              Text(AppLocalizations.of(context).translate('no_subjects'))
            ],
          ),
        ),
      );
    }
    return SubjectsGrid(
      subjects: GlobalUtils.removeUnwantedSubject(subjects),
      grades: grades,
      period: period ?? -3,
    );
  }
}
