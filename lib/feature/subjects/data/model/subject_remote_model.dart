import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/professors/data/model/professor_remote_model.dart';
import 'package:registro_elettronico/utils/color_utils.dart';
import 'package:registro_elettronico/utils/global_utils.dart';

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
      professors = [];
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

  SubjectLocalModel toLocalModel(int index) {
    return SubjectLocalModel(
      id: this.id ?? -1,
      name: this.description ?? '',
      orderNumber: this.order ?? -1,
      color: GlobalUtils.getColorCode(
            ColorUtils.getColorFromIndex(index) ?? Colors.red,
          ) ??
          Colors.red.value.toString(),
    );
  }
}
