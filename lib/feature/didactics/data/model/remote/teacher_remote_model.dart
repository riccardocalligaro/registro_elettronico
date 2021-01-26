import 'package:registro_elettronico/core/data/local/moor_database.dart';

import 'folder_remote_model.dart';

class TeacherRemoteModel {
  String teacherId;
  String teacherName;
  String teacherFirstName;
  String teacherLastName;
  List<FolderRemoteModel> folders;

  TeacherRemoteModel({
    this.teacherId,
    this.teacherName,
    this.teacherFirstName,
    this.teacherLastName,
    this.folders,
  });

  TeacherLocalModel toLocalModel() {
    return TeacherLocalModel(
      id: this.teacherId ?? -1,
      name: this.teacherName ?? '',
      firstName: this.teacherFirstName ?? '',
      lastName: this.teacherLastName ?? '',
    );
  }

  TeacherRemoteModel.fromJson(Map<String, dynamic> json) {
    teacherId = json['teacherId'];
    teacherName = json['teacherName'];
    teacherFirstName = json['teacherFirstName'];
    teacherLastName = json['teacherLastName'];
    if (json['folders'] != null) {
      folders = List<FolderRemoteModel>();
      json['folders'].forEach((v) {
        folders.add(FolderRemoteModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['teacherId'] = this.teacherId;
    data['teacherName'] = this.teacherName;
    data['teacherFirstName'] = this.teacherFirstName;
    data['teacherLastName'] = this.teacherLastName;
    if (this.folders != null) {
      data['folders'] = this.folders.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
