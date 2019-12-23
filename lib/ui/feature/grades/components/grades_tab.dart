import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/grades/bloc.dart';
import 'package:registro_elettronico/ui/bloc/grades/grades_bloc.dart';
import 'package:registro_elettronico/ui/feature/grades/components/grade_subject_card.dart';
import 'package:registro_elettronico/ui/feature/grades/components/grades_chart.dart';
import 'package:registro_elettronico/ui/feature/grades/components/grades_overall_stats.dart';
import 'package:registro_elettronico/ui/feature/widgets/grade_card.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/constants/tabs_constants.dart';
import 'package:registro_elettronico/utils/entity/overall_stats.dart';
import 'package:registro_elettronico/utils/global_utils.dart';

class GradeTab extends StatefulWidget {
  final int period;

  const GradeTab({Key key, @required this.period}) : super(key: key);

  @override
  _GradeTabState createState() => _GradeTabState();
}

class _GradeTabState extends State<GradeTab>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    BlocProvider.of<GradesBloc>(context).add(GetGradesAndSubjects());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: _test,
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
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _buildStatsCard(grades, subjects),
          _buildAverageGradesForSubjectsList(grades, subjects),
        ],
      ),
    );
  }

  // Card that shows the overall stats of the student
  Widget _buildStatsCard(List<Grade> grades, List<Subject> subjects) {
    OverallStats stats;
    if (grades.length >= 2) {
      stats = GlobalUtils.getOverallStatsFromSubjectGradesMap(
          subjects, grades, widget.period);
    }

    if (stats != null) {
      return GradesOverallStats(
        grades: grades,
        stats: stats,
      );
    }
    return Container();
  }

  Widget _buildGradesChart(Map<dynamic, List<Grade>> grades) {
    return Container(
      child: GradesChart(
        grades: _getGradesListForPeriodFromMap(grades),
      ),
    );
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
    Map<Subject, double> subjectsValues = Map.fromIterable(subjects,
        key: (e) => e, value: (e) => GlobalUtils.getAverage(e.id, grades));
    final period = widget.period;
    // Get the grades in the rigt order

    List<Grade> gradesForPeriod;
    if (period == TabsConstants.GENERALE) {
      gradesForPeriod = grades;
    } else {
      gradesForPeriod =
          grades.where((grade) => grade.periodPos == widget.period).toList();
    }

    var sortedKeys = subjectsValues.keys.toList()
      ..removeWhere((subject) {
        bool contains = true;
        grades.forEach((grade) {
          if (grade.subjectId == subject.id) {
            contains = false;
          }
        });
        return contains;
      })
      ..sort((k2, k1) => subjectsValues[k1].compareTo(subjectsValues[k2]));

    LinkedHashMap<Subject, double> sortedMap = new LinkedHashMap.fromIterable(
        sortedKeys,
        key: (k) => k,
        value: (k) => subjectsValues[k]);

    if (gradesForPeriod.length > 0) {
      return IgnorePointer(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: sortedMap.keys.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: GradeSubjectCard(
                  subject: sortedMap.keys.elementAt(index),
                  grades: gradesForPeriod,
                ),
              );
            },
          ),
        ),
      );
    } else {
      return Text('No grades!');
    }
  }

  List<Grade> getGradesOrderedByAverage(List<Grade> grades) {
    // todo: add different type of order
  }

  Widget _buildEmpty() {
    return Center(
      child: Text(
        AppLocalizations.of(context).translate('nothing_here'),
      ),
    );
  }

  Future<void> _test() async {}

  @override
  bool get wantKeepAlive => true;

  List _getGradesListForPeriodFromMap(Map<dynamic, List<Grade>> grades) {
    final List<Grade> gradesList = [];
    grades.forEach((subject, grades) => grades.forEach((grade) {
          if (grade.periodPos == widget.period ||
              widget.period == TabsConstants.GENERALE) {
            gradesList.add(grade);
          }
        }));
    gradesList.sort((b, a) => a.eventDate.compareTo(b.eventDate));

    return gradesList;
  }
}
