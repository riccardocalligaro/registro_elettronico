import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/domain/entity/subject_objective.dart';
import 'package:registro_elettronico/ui/bloc/grades/subject_grades/bloc.dart';
import 'package:registro_elettronico/ui/feature/grades/components/grade_subject_card.dart';
import 'package:registro_elettronico/ui/feature/grades/components/overall_stats_card.dart';
import 'package:registro_elettronico/ui/feature/widgets/cusotm_placeholder.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/constants/tabs_constants.dart';
import 'package:registro_elettronico/utils/grades_utils.dart';

class TermGradesPage extends StatefulWidget {
  final List<Grade> grades;
  final List<Subject> subjects;
  final List<SubjectObjective> objectives;
  final int periodPosition;
  final int generalObjective;

  const TermGradesPage({
    Key key,
    @required this.grades,
    @required this.periodPosition,
    @required this.subjects,
    @required this.objectives,
    @required this.generalObjective,
  }) : super(key: key);

  @override
  _TermGradesPageState createState() => _TermGradesPageState();
}

class _TermGradesPageState extends State<TermGradesPage> {
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();

    _refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    List<Grade> gradesForThisPeriod;
    if (widget.periodPosition != TabsConstants.GENERALE) {
      gradesForThisPeriod = widget.grades
          .where((g) => g.periodPos == widget.periodPosition)
          .toList();
    } else {
      gradesForThisPeriod = widget.grades;
    }
    return RefreshIndicator(
        onRefresh: () {
          BlocProvider.of<SubjectsGradesBloc>(context)
              .add(UpdateSubjectGrades());
          BlocProvider.of<SubjectsGradesBloc>(context)
              .add(GetGradesAndSubjects());
          return _refreshCompleter.future;
        },
        child: _buildStatsAndAverages(
            gradesForThisPeriod, widget.subjects, widget.objectives, context));
  }

  Widget _buildStatsAndAverages(
    List<Grade> grades,
    List<Subject> subjects,
    List<SubjectObjective> objective,
    BuildContext context,
  ) {
    if (grades.length > 0) {
      return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildStatsCard(grades),
            _buildAverageGradesForSubjectsList(grades, subjects),
          ],
        ),
      );
    }

    return Center(
      child: CustomPlaceHolder(
        text: AppLocalizations.of(context).translate('no_grades'),
        icon: Icons.timeline,
        showUpdate: false,
      ),
    );
  }

  Widget _buildStatsCard(List<Grade> grades) {
    double average;
    average = GradesUtils.getAverageWithoutSubjectId(grades);

    if (!average.isNaN) {
      return OverallStatsCard(
        grades: grades,
        average: average,
        objective: widget.generalObjective,
      );
    }

    return Container();
  }

  Widget _buildAverageGradesForSubjectsList(
    List<Grade> grades,
    List<Subject> subjects,
  ) {
    final sortedMap = _getGradesOrderedByAverage(grades, subjects, false);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: sortedMap.keys.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: GradeSubjectCard(
              subject: sortedMap.keys.elementAt(index),
              grades: grades,
              objective: widget.objectives
                  .where(
                      (o) => o.subjectId == sortedMap.keys.elementAt(index).id)
                  .single
                  .objective,
              period: widget.periodPosition,
            ),
          );
        },
      ),
    );
  }

  LinkedHashMap<Subject, double> _getGradesOrderedByAverage(
    List<Grade> grades,
    List<Subject> subjects,
    bool ascending,
  ) {
    Map<Subject, double> subjectsValues = Map.fromIterable(subjects,
        key: (e) => e, value: (e) => GradesUtils.getAverage(e.id, grades));

    var sortedKeys = subjectsValues.keys.toList()
      ..removeWhere((subject) {
        bool contains = true;
        grades.forEach((grade) {
          if (grade.subjectId == subject.id) {
            contains = false;
          }
        });
        return contains;
      });

    if (ascending) {
      sortedKeys = sortedKeys
        ..sort((k1, k2) => subjectsValues[k1].compareTo(subjectsValues[k2]));
    } else {
      sortedKeys = sortedKeys
        ..sort((k2, k1) => subjectsValues[k1].compareTo(subjectsValues[k2]));
    }

    LinkedHashMap<Subject, double> sortedMap = new LinkedHashMap.fromIterable(
        sortedKeys,
        key: (k) => k,
        value: (k) => subjectsValues[k]);
    return sortedMap;
  }
}
