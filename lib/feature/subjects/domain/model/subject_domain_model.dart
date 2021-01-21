import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/professors/domain/model/professor_domain_model.dart';

class SubjectDomainModel {
  int id;
  String name;
  int order;
  List<ProfessorDomainModel> professors;

  SubjectDomainModel({
    @required this.id,
    @required this.name,
    @required this.order,
    @required this.professors,
  });

  SubjectDomainModel.fromLocalModel({
    @required List<ProfessorDomainModel> professors,
    @required SubjectLocalModel l,
  }) {
    this.id = l.id;
    this.name = l.name;
    this.order = l.orderNumber;
    this.professors = professors;
  }
}
