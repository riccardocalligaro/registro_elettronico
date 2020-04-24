import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/grades/subject_grades/bloc.dart';
import 'package:registro_elettronico/ui/feature/widgets/cusotm_placeholder.dart';
import 'package:registro_elettronico/ui/feature/widgets/grade_card.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';

/// Page of the [last grades]
class LastGradesPage extends StatefulWidget {
  final List<Grade> grades;

  const LastGradesPage({
    Key key,
    @required this.grades,
  }) : super(key: key);

  @override
  _LastGradesPageState createState() => _LastGradesPageState();
}

class _LastGradesPageState extends State<LastGradesPage> {
  RefreshController _refreshController;

  @override
  void initState() {
    // refresh controlelr for udpading grades
    _refreshController = RefreshController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SubjectsGradesBloc, SubjectsGradesState>(
      listener: (context, state) {
        if (state is SubjectsGradesUpdateLoadSuccess) {
          _refreshController.refreshCompleted();
        } else if (state is SubjectsGradesLoadError ||
            state is SubjectsGradesLoadNotConnected) {
          _refreshController.refreshFailed();
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SmartRefresher(
          controller: _refreshController,
          header: WaterDropMaterialHeader(
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[900]
                : Colors.white,
            color: Colors.red,
          ),
          onRefresh: () {
            BlocProvider.of<SubjectsGradesBloc>(context)
                .add(UpdateSubjectGrades());
          },
          child: _buildGradesList(),
        ),
      ),
    );
  }

  Widget _buildGradesList() {
    if (widget.grades.length > 0) {
      return ListView.builder(
        padding: EdgeInsets.only(bottom: 16.0),
        itemCount: widget.grades.length,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: GradeCard(
                grade: widget.grades[index],
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: GradeCard(
              grade: widget.grades[index],
            ),
          );
        },
      );
    } else {
      return CustomPlaceHolder(
        icon: Icons.timeline,
        showUpdate: true,
        onTap: () {
          BlocProvider.of<SubjectsGradesBloc>(context)
              .add(UpdateSubjectGrades());
          _refreshController.requestRefresh();
        },
        text: AppLocalizations.of(context).translate('no_grades'),
      );
    }
  }
}
