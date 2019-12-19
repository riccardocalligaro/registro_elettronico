import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/grades/bloc.dart';
import 'package:registro_elettronico/ui/bloc/grades/grades_bloc.dart';
import 'package:registro_elettronico/ui/feature/grades/components/grade_chart.dart';
import 'package:registro_elettronico/ui/feature/widgets/grade_card.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/constants/tabs_constants.dart';

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

              if (period == TabsConstants.GENERALE) {
                //return _buildAverageGradesForSubjectsList(state.data.values.);
              } else if (period == TabsConstants.ULTIMI_VOTI) {
                //return _buildGradesList(state.data);
              } else {
                return _buildAverageGradesForSubjectsList(state.data);
                //final grades = state.grades
                //     .where((grade) => grade.periodPos == widget.period)
                //     .toList();
                // return grades.length > 0
                //     ? _buildAverageGradesForSubjectsList(grades)
                //     : _buildEmpty();
              }
              return Text('Not defined');
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGradesList(List<Grade> grades) {
    return Column(
      children: <Widget>[
        GradesChart(
          grades: grades,
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: grades.length,
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[],
            );
          },
        ),
      ],
    );
  }

  Widget _buildAverageGradesForSubjectsList(Map<dynamic, List<Grade>> grades) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: grades.keys.length,
        itemBuilder: (context, index) {
          Subject key = grades.keys.elementAt(index);
          print(grades.keys.elementAt(index).id);

          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Column(
              children: <Widget>[
                Text(key.name),
                IgnorePointer(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: grades[key].length,
                    itemBuilder: (ctx, index) {
                      final Grade grade = grades[key][index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: GradeCard(
                          grade: grade,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Text(
        AppLocalizations.of(context).translate('nothing_here'),
      ),
    );
  }

  Future<void> _test() async {
    //BlocProvider.of(context).add(FetchGrades());
  }

  @override
  bool get wantKeepAlive => true;
}
