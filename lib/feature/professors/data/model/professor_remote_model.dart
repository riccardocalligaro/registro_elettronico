import 'package:registro_elettronico/core/data/local/moor_database.dart';

class ProfessorRemoteModel {
  String teacherId;
  String teacherName;

  ProfessorRemoteModel({this.teacherId, this.teacherName});

  ProfessorRemoteModel.fromJson(Map<String, dynamic> json) {
    teacherId = json['teacherId'];
    teacherName = json['teacherName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['teacherId'] = this.teacherId;
    data['teacherName'] = this.teacherName;
    return data;
  }

  ProfessorLocalModel toLocalModel(int subjectId) {
    return ProfessorLocalModel(
      id: this.teacherId ?? -1,
      subjectId: subjectId ?? -1,
      name: this.teacherName ?? '',
    );
  }
}
