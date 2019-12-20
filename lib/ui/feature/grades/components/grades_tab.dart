import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/grades/bloc.dart';
import 'package:registro_elettronico/ui/bloc/grades/grades_bloc.dart';
import 'package:registro_elettronico/ui/feature/widgets/grade_card.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/constants/tabs_constants.dart';
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
    //blocProvider.of<GradesBloc>(context).add(GetGrades());

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
              print("length" + state.data.values.length.toString());
              if (state.data.values.length > 0) {
                if (period == TabsConstants.GENERALE) {
                  return _buildAverageGradesForSubjectsList(state.data);
                } else if (period == TabsConstants.ULTIMI_VOTI) {
                  return _buildGradesList(state.data);
                } else {
                  return _buildAverageGradesForSubjectsList(state.data);
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

  Widget _buildGradesList(Map<dynamic, List<Grade>> grades) {
    List<Grade> gradesList = [];
    grades.forEach(
        (subject, grades) => grades.forEach((grade) => gradesList.add(grade)));
    gradesList.sort((b, a) => a.eventDate.compareTo(b.eventDate));

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: gradesList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: GradeCard(
              grade: gradesList[index],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsCard(Map<dynamic, List<Grade>> grades) {
    final all_grades = grades.values.toList();
    all_grades.forEach((grade) {
      grade.forEach((single) {
        print(single.displayValue);
      });
    });
  }

  Widget _buildAverageGradesForSubjectsList(Map<dynamic, List<Grade>> grades) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: grades.keys.length,
        itemBuilder: (context, index) {
          Subject key = grades.keys.elementAt(index);
          final period = widget.period;
          List<Grade> gradesForPeriod;
          if (period == TabsConstants.GENERALE) {
            gradesForPeriod = grades[key];
          } else {
            gradesForPeriod = grades[key]
                .where((grade) => grade.periodPos == widget.period)
                .toList();
          }

          if (gradesForPeriod.length > 0) {
            final averages =
                GlobalUtils.getSubjectAveragesFromGrades(gradesForPeriod);
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(key.name),
                  Text(
                    "Media totale: ${averages.averageValue}",
                  ),
                  Text(
                    "Media pratica: ${averages.praticoAverageValue}",
                  ),
                  Text(
                    "Media scritta: ${averages.scrittoAverageValue}",
                  ),
                  Text(
                    "Media orale: ${averages.oraleAverageValue}",
                  ),
                ],
              ),
            );
          } else {
            return Container();
          }
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
