import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures_v2.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/core/presentation/widgets/cusotm_placeholder.dart';
import 'package:registro_elettronico/feature/grades/domain/model/grade_domain_model.dart';
import 'package:registro_elettronico/feature/grades/presentation/updater/grades_updater_bloc.dart';
import 'package:registro_elettronico/feature/grades/presentation/watcher/grades_watcher_bloc.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:registro_elettronico/utils/global_utils.dart';
import 'package:registro_elettronico/utils/string_utils.dart';

class LastGradesSection extends StatelessWidget {
  const LastGradesSection({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GradesWatcherBloc, GradesWatcherState>(
      builder: (context, state) {
        if (state is GradesWatcherLoadSuccess) {
          return _LastGradesLoaded(
            grades: state.gradesSections.grades.take(3).toList(),
          );
        } else if (state is GradesWatcherFailure) {
          return _LastGradesError(failure: state.failure);
        }

        return _LastGradesLoading();
      },
    );
  }
}

class _LastGradesLoaded extends StatelessWidget {
  final List<GradeDomainModel> grades;

  const _LastGradesLoaded({
    Key key,
    @required this.grades,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (grades.isNotEmpty) {
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

  Widget _buildListViewCard(GradeDomainModel grade, BuildContext context) {
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
  }
}

class _LastGradesLoading extends StatelessWidget {
  const _LastGradesLoading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 100.0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _LastGradesError extends StatelessWidget {
  final Failure failure;

  const _LastGradesError({
    Key key,
    @required this.failure,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPlaceHolder(
      icon: Icons.error,
      text: failure.localizedDescription(context),
      showUpdate: true,
      onTap: () {
        BlocProvider.of<GradesUpdaterBloc>(context).add(UpdateGrades());
      },
    );
  }
}
