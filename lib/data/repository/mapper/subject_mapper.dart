import 'package:flutter/material.dart';
import 'package:registro_elettronico/data/db/moor_database.dart' as db;
import 'package:registro_elettronico/domain/entity/api_responses/subjects_response.dart';
import 'package:registro_elettronico/utils/color_utils.dart';
import 'package:registro_elettronico/utils/global_utils.dart';

class SubjectMapper {
  /// Converts a lesson we got from the api to an insertable in the database
  static db.Subject convertSubjectEntityToInsertable(
      Subjects subject, int index) {
    return db.Subject(
            id: subject.id ?? -1,
            name: subject.description ?? "",
            orderNumber: subject.order ?? -1,
            color: GlobalUtils.getColorCode(
                ColorUtils.getColorFromIndex(index) ?? Colors.red)) ??
        Colors.red.value.toString();
  }

  static db.Professor convertProfessorEntityToInsertable(
      Teachers professor, int subjectId) {
    return db.Professor(
      id: professor.teacherId ?? "",
      subjectId: subjectId ?? -1,
      name: professor.teacherName ?? "",
    );
  }
}
