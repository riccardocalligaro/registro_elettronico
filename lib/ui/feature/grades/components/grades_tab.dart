import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/grades/bloc.dart';
import 'package:registro_elettronico/ui/bloc/grades/grades_bloc.dart';
import 'package:registro_elettronico/ui/feature/grades/components/grade_subject_card.dart';
import 'package:registro_elettronico/ui/feature/grades/components/grades_overall_stats.dart';
import 'package:registro_elettronico/ui/feature/widgets/cusotm_placeholder.dart';
import 'package:registro_elettronico/ui/feature/widgets/grade_card.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/constants/tabs_constants.dart';
import 'package:registro_elettronico/utils/grades_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GradeTab extends StatefulWidget {
  final int period;

  const GradeTab({Key key, @required this.period}) : super(key: key);

  @override
  _GradeTabState createState() => _GradeTabState();
}

class _GradeTabState extends State<GradeTab> {
  bool _ascending = false;

  @override
  void initState() {
    super.initState();
  }

  restore() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _ascending = (preferences.getBool('sorting_ascending') ?? false);
      });
    }
  }

  @override
  void didChangeDependencies() {
    restore();
    BlocProvider.of<GradesBloc>(context).add(GetGradesAndSubjects());
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _updateGrades,
      child: Container(
        child: BlocBuilder<GradesBloc, GradesState>(
          builder: (context, state) {
            if (state is GradesAndSubjectsLoaded) {
              final period = widget.period;
              if (state.grades.length > 0) {
                if (period == TabsConstants.GENERALE) {
                  return _buildStatsAndAverages(state.grades, state.subject);
                } else if (period == TabsConstants.ULTIMI_VOTI) {
                  return _buildGradesList(state.grades);
                } else {
                  return _buildStatsAndAverages(state.grades, state.subject);
                  //return _buildStatsAndAverages(state.data);
                }
              } else {
                return _buildEmpty();
              }
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatsAndAverages(List<Grade> grades, List<Subject> subjects) {
    if (widget.period == TabsConstants.GENERALE) {
      grades = grades;
    } else {
      grades =
          grades.where((grade) => grade.periodPos == widget.period).toList();
    }

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

  // Card that shows the overall stats of the student
  Widget _buildStatsCard(List<Grade> grades) {
    double average;
    average = GradesUtils.getAverageWithoutSubjectId(grades);

    if (!average.isNaN) {
      return GradesOverallStats(
        grades: grades,
        average: average,
      );
    }

    return Container();
  }

  /// This is for the [Last grades], it takes the grades
  /// from the bloc and it sorts them in descending order
  Widget _buildGradesList(List<Grade> grades) {
    grades.sort((b, a) => a.eventDate.compareTo(b.eventDate));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.builder(
        itemCount: grades.length,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: GradeCard(
                grade: grades[index],
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: GradeCard(
              grade: grades[index],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAverageGradesForSubjectsList(
      List<Grade> grades, List<Subject> subjects) {
    final sortedMap = _getGradesOrderedByAverage(grades, subjects, _ascending);
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
              period: widget.period,
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

  Widget _buildEmpty() {
    return CustomPlaceHolder(
      text: AppLocalizations.of(context).translate('no_grades'),
      icon: Icons.timeline,
      showUpdate: true,
      onTap: _updateGrades,
    );
  }

  Future<void> _updateGrades() async {
    BlocProvider.of<GradesBloc>(context).add(FetchGrades());
    BlocProvider.of<GradesBloc>(context).add(GetGradesAndSubjects());
  }
}
