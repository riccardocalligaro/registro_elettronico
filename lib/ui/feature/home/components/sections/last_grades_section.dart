import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/bloc/grades/bloc.dart';
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

  StreamBuilder<List<Grade>> _buildLastGrades(BuildContext context) {
    return StreamBuilder(
      stream: BlocProvider.of<GradesBloc>(context).watchNumberOfGradesByDate(),
      initialData: List<Grade>(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final List<Grade> grades =
            snapshot.data.toSet().toList() ?? List<Grade>();

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
      },
    );
  }
}
