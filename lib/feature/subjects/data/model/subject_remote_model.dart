import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/professors/data/model/professor_remote_model.dart';

class SubjectRemoteModel {
  int id;
  String description;
  int order;
  List<ProfessorRemoteModel> professors;

  SubjectRemoteModel({
    this.id,
    this.description,
    this.order,
    this.professors,
  });

  SubjectRemoteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    order = json['order'];
    if (json['teachers'] != null) {
      professors = List<ProfessorRemoteModel>();
      json['teachers'].forEach((v) {
        professors.add(ProfessorRemoteModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['order'] = this.order;
    if (this.professors != null) {
      data['teachers'] = this.professors.map((v) => v.toJson()).toList();
    }
    return data;
  }

  SubjectLocalModel toLocalModel() {
    return SubjectLocalModel(
      id: this.id,
      name: this.description,
      orderNumber: this.order,
      color: '',
    );
  }
}
