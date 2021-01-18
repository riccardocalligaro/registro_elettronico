import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/presentation/widgets/grade_card.dart';
import 'package:registro_elettronico/feature/grades/domain/model/grades_section.dart';

class GradesLoaded extends StatelessWidget {
  final GradesPagesDomainModel gradesPagesDomainModel;

  const GradesLoaded({
    Key key,
    @required this.gradesPagesDomainModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(gradesPagesDomainModel.grades[0].toString());
    // return GradeCard(
    //   grade: sections[1].grades.length.toString(),
    // );
  }
}
