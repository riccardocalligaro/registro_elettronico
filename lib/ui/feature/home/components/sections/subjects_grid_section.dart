import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/grades/bloc.dart';
import 'package:registro_elettronico/ui/bloc/grades/subject_grades/bloc.dart';
import 'package:registro_elettronico/ui/feature/home/components/widgets/subjects_grid.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/constants/tabs_constants.dart';
import 'package:registro_elettronico/utils/global_utils.dart';

class SubjectsGridSection extends StatelessWidget {
  final Period period;

  const SubjectsGridSection({Key key, this.period}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<SubjectsGradesBloc>(context).add(GetGradesAndSubjects());
    return BlocListener<GradesBloc, GradesState>(
      listener: (context, state) {
        if (state is GradesUpdateLoaded)
          BlocProvider.of<SubjectsGradesBloc>(context)
              .add(GetGradesAndSubjects());
      },
      child: _buildSubjectsBlocBuilder(context),
    );
  }

  BlocBuilder _buildSubjectsBlocBuilder(BuildContext context) {
    return BlocBuilder<SubjectsGradesBloc, SubjectsGradesState>(
      builder: (context, state) {
        if (state is SubjectsGradesLoadInProgress) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is SubjectsGradesLoadSuccess) {
          return _buildSubjectsGrid(state.subjects, state.grades, context);
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
      period: period == null ? TabsConstants.GENERALE : period.position,
    );
  }
}
