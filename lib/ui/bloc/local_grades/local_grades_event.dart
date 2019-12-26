import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';

abstract class LocalGradesEvent extends Equatable {
  const LocalGradesEvent();

  @override
  List<Object> get props => [];
}

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
