import 'dart:convert';

import 'package:registro_elettronico/core/data/local/moor_database.dart';

class AttachmentDomainModel {
  int? id;
  int? pubId;
  String? fileName;
  int? attachNumber;

  AttachmentDomainModel({
    required this.id,
    required this.pubId,
    required this.fileName,
    required this.attachNumber,
  });

  AttachmentDomainModel.fromLocalModel(NoticeAttachmentLocalModel l) {
    this.id = l.id;
    this.pubId = l.pubId;
    this.fileName = l.fileName;
    this.attachNumber = l.attachNumber;
  }

  AttachmentDomainModel copyWith({
    int? id,
    int? pubId,
    String? fileName,
    int? attachNumber,
  }) {
    return AttachmentDomainModel(
      id: id ?? this.id,
      pubId: pubId ?? this.pubId,
      fileName: fileName ?? this.fileName,
      attachNumber: attachNumber ?? this.attachNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pubId': pubId,
      'fileName': fileName,
      'attachNumber': attachNumber,
    };
  }

  static AttachmentDomainModel? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;

    return AttachmentDomainModel(
      id: map['id'],
      pubId: map['pubId'],
      fileName: map['fileName'],
      attachNumber: map['attachNumber'],
    );
  }

  String toJson() => json.encode(toMap());

  static AttachmentDomainModel? fromJson(String source) =>
      AttachmentDomainModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AttachmentDomainModel(id: $id, pubId: $pubId, fileName: $fileName, attachNumber: $attachNumber)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is AttachmentDomainModel &&
        o.id == id &&
        o.pubId == pubId &&
        o.fileName == fileName &&
        o.attachNumber == attachNumber;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        pubId.hashCode ^
        fileName.hashCode ^
        attachNumber.hashCode;
  }
}
