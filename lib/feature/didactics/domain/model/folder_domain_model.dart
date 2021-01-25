import 'package:flutter/foundation.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/didactics/domain/model/content_domain_model.dart';

class FolderDomainModel {
  int id;
  String teacherId;
  String name;
  DateTime lastShareDate;
  List<ContentDomainModel> contents;

  FolderDomainModel({
    this.id,
    this.name,
    this.lastShareDate,
    this.contents,
    this.teacherId,
  });

  FolderDomainModel.fromLocalModel({
    @required FolderLocalModel l,
    @required List<ContentDomainModel> contents,
  }) {
    this.id = l.id;
    this.teacherId = l.teacherId;
    this.name = l.name;
    this.lastShareDate = l.lastShare;
    this.contents = contents;
  }

  @override
  String toString() {
    return 'FolderDomainModel(id: $id, teacherId: $teacherId, name: $name, lastShareDate: $lastShareDate, contents: $contents)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is FolderDomainModel &&
        o.id == id &&
        o.teacherId == teacherId &&
        o.name == name &&
        o.lastShareDate == lastShareDate &&
        listEquals(o.contents, contents);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        teacherId.hashCode ^
        name.hashCode ^
        lastShareDate.hashCode ^
        contents.hashCode;
  }
}
