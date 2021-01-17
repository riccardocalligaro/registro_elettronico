import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/presentation/widgets/grade_card.dart';
import 'package:registro_elettronico/feature/grades/domain/model/grades_section.dart';

class GradesLoaded extends StatelessWidget {
  final List<GradeSectionDomainModel> sections;

  const GradesLoaded({
    Key key,
    @required this.sections,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(sections[2].grades.length.toString());
    // return GradeCard(
    //   grade: sections[1].grades.length.toString(),
    // );
  }
}
