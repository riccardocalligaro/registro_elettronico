import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:registro_elettronico/core/data/local/moor_database.dart';

class ProfessorDomainModel {
  String? id;
  String? name;
  int? subjectId;

  ProfessorDomainModel({
    required this.id,
    required this.name,
    required this.subjectId,
  });

  ProfessorDomainModel.fromLocalModel(ProfessorLocalModel l) {
    this.id = l.id;
    this.name = l.name;
    this.subjectId = l.subjectId;
  }

  ProfessorDomainModel copyWith({
    String? id,
    String? name,
    int? subjectId,
  }) {
    return ProfessorDomainModel(
      id: id ?? this.id,
      name: name ?? this.name,
      subjectId: subjectId ?? this.subjectId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'subjectId': subjectId,
    };
  }

  factory ProfessorDomainModel.fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;

    return ProfessorDomainModel(
      id: map['id'],
      name: map['name'],
      subjectId: map['subjectId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfessorDomainModel.fromJson(String source) =>
      ProfessorDomainModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'ProfessorDomainModel(id: $id, name: $name, subjectId: $subjectId)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ProfessorDomainModel &&
        o.id == id &&
        o.name == name &&
        o.subjectId == subjectId;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ subjectId.hashCode;
}
