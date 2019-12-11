class SubjectsResponse {
  List<Subjects> subjects;

  SubjectsResponse({this.subjects});

  SubjectsResponse.fromJson(Map<String, dynamic> json) {
    if (json['subjects'] != null) {
      subjects = new List<Subjects>();
      json['subjects'].forEach((v) {
        subjects.add(new Subjects.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.subjects != null) {
      data['subjects'] = this.subjects.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Subjects {
  int id;
  String description;
  int order;
  List<Teachers> teachers;

  Subjects({this.id, this.description, this.order, this.teachers});

  Subjects.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    order = json['order'];
    if (json['teachers'] != null) {
      teachers = new List<Teachers>();
      json['teachers'].forEach((v) {
        teachers.add(new Teachers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['order'] = this.order;
    if (this.teachers != null) {
      data['teachers'] = this.teachers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Teachers {
  String teacherId;
  String teacherName;

  Teachers({this.teacherId, this.teacherName});

  Teachers.fromJson(Map<String, dynamic> json) {
    teacherId = json['teacherId'];
    teacherName = json['teacherName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['teacherId'] = this.teacherId;
    data['teacherName'] = this.teacherName;
    return data;
  }
}
