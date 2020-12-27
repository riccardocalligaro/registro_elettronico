part of 'local_grades_bloc.dart';

@immutable
abstract class LocalGradesEvent {}

/// Gets the [local] grades
class GetLocalGrades extends LocalGradesEvent {
  final int period;

  GetLocalGrades({@required this.period});
}

class AddLocalGrade extends LocalGradesEvent {
  final LocalGrade localGrade;

  AddLocalGrade({
    @required this.localGrade,
  });
}

class DeleteLocalGrade extends LocalGradesEvent {
  final LocalGrade localGrade;

  DeleteLocalGrade({
    @required this.localGrade,
  });
}

class UpdateLocalGrade extends LocalGradesEvent {
  final LocalGrade localGrade;

  UpdateLocalGrade({
    @required this.localGrade,
  });
}
