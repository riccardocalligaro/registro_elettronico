import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/didactics/domain/model/didactics_file.dart';

class ContentDomainModel {
  int id;
  String name;
  int objectId;
  ContentType type;
  DateTime shareDate;
  List<DidacticsFile> files;

  ContentDomainModel({
    this.id,
    this.name,
    this.objectId,
    this.type,
    this.shareDate,
    this.files,
  });

  ContentDomainModel.fromLocalModel({
    @required ContentLocalModel l,
    @required List<DidacticsFile> files,
  }) {
    this.id = l.id;
    this.name = l.name;
    this.objectId = l.objectId;
    this.type = _typeFromName(l.type);
    this.shareDate = l.date;
    this.files = files;
  }

  ContentType _typeFromName(String type) {
    if (type == 'link') {
      return ContentType.url;
    } else if (type == 'text') {
      return ContentType.text;
    } else {
      return ContentType.file;
    }
  }

  @override
  String toString() {
    return 'ContentDomainModel(id: $id, name: $name, objectId: $objectId, type: $type, shareDate: $shareDate, files: $files)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ContentDomainModel &&
        o.id == id &&
        o.name == name &&
        o.objectId == objectId &&
        o.type == type &&
        o.shareDate == shareDate &&
        listEquals(o.files, files);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        objectId.hashCode ^
        type.hashCode ^
        shareDate.hashCode ^
        files.hashCode;
  }
}

enum ContentType { file, text, url }
