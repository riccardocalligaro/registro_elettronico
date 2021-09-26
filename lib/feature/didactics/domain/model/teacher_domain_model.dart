import 'package:flutter/foundation.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/didactics/domain/model/folder_domain_model.dart';

class DidacticsTeacherDomainModel {
  String? id;
  String? name;
  String? firstName;
  String? lastName;
  List<FolderDomainModel>? folders;

  DidacticsTeacherDomainModel({
    required this.id,
    required this.name,
    required this.firstName,
    required this.lastName,
    required this.folders,
  });

  DidacticsTeacherDomainModel.fromLocalModel({
    required TeacherLocalModel localModel,
    required List<FolderDomainModel> folders,
  }) {
    this.id = localModel.id;
    this.name = localModel.name;
    this.firstName = localModel.firstName;
    this.lastName = localModel.lastName;
    this.folders = folders;
  }

  DidacticsTeacherDomainModel copyWith({
    String? id,
    String? name,
    String? firstName,
    String? lastName,
    List<FolderDomainModel>? folders,
  }) {
    return DidacticsTeacherDomainModel(
      id: id ?? this.id,
      name: name ?? this.name,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      folders: folders ?? this.folders,
    );
  }

  @override
  String toString() {
    return 'DidacticsTeacherDomainModel(id: $id, name: $name, firstName: $firstName, lastName: $lastName, folders: $folders)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is DidacticsTeacherDomainModel &&
        o.id == id &&
        o.name == name &&
        o.firstName == firstName &&
        o.lastName == lastName &&
        listEquals(o.folders, folders);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        folders.hashCode;
  }
}
