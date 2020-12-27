class SubjectsResponse {
  List<SubjectRemoteModel> subjects;

  SubjectsResponse({this.subjects});

  SubjectsResponse.fromJson(Map<String, dynamic> json) {
    if (json['subjects'] != null) {
      subjects = List<SubjectRemoteModel>();
      json['subjects'].forEach((v) {
        subjects.add(SubjectRemoteModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.subjects != null) {
      data['subjects'] = this.subjects.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubjectRemoteModel {
  int id;
  String description;
  int order;
  List<TeacherRemoteModel> teachers;

  SubjectRemoteModel({this.id, this.description, this.order, this.teachers});

  SubjectRemoteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    order = json['order'];
    if (json['teachers'] != null) {
      teachers = List<TeacherRemoteModel>();
      json['teachers'].forEach((v) {
        teachers.add(TeacherRemoteModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['order'] = this.order;
    if (this.teachers != null) {
      data['teachers'] = this.teachers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TeacherRemoteModel {
  String teacherId;
  String teacherName;

  TeacherRemoteModel({this.teacherId, this.teacherName});

  TeacherRemoteModel.fromJson(Map<String, dynamic> json) {
    teacherId = json['teacherId'];
    teacherName = json['teacherName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['teacherId'] = this.teacherId;
    data['teacherName'] = this.teacherName;
    return data;
  }
}
