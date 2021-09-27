import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/noticeboard/domain/model/attachment_domain_model.dart';

class NoticeDomainModel {
  int? id;
  DateTime? date;
  bool? readStatus;
  String? code;
  int? contentId;
  DateTime? validFrom;
  DateTime? validTo;
  bool? validInRange;
  String? status;
  String? contentTitle;
  String? contentCategory;
  bool? hasChanged;
  bool? hasAttach;
  bool? needJoin;
  bool? needReply;
  bool? needFile;
  List<AttachmentDomainModel>? attachments;

  NoticeDomainModel({
    this.id,
    this.date,
    this.readStatus,
    this.code,
    this.contentId,
    this.validFrom,
    this.validTo,
    this.validInRange,
    this.status,
    this.contentTitle,
    this.contentCategory,
    this.hasChanged,
    this.hasAttach,
    this.needJoin,
    this.needReply,
    this.needFile,
    this.attachments,
  });

  NoticeDomainModel.fromLocalModel({
    required NoticeLocalModel l,
    required List<AttachmentDomainModel>? attachments,
  }) {
    this.id = l.pubId;
    this.date = l.pubDate;
    this.readStatus = l.readStatus;
    this.code = l.eventCode;
    this.contentId = l.contentId;
    this.validFrom = l.contentValidFrom;
    this.validTo = l.contentValidTo;
    this.validInRange = l.contentValidInRange;
    this.status = l.contentStatus;
    this.contentTitle = l.contentTitle;
    this.contentCategory = l.contentCategory;
    this.hasChanged = l.contentHasChanged;
    this.hasAttach = l.contentHasAttach;
    this.needJoin = l.needJoin;
    this.needReply = l.needReply;
    this.needFile = l.needFile;
    this.attachments = attachments;
  }

  NoticeLocalModel toLocalModel() {
    return NoticeLocalModel(
      pubId: this.id,
      pubDate: this.date,
      readStatus: this.readStatus,
      eventCode: this.code,
      contentId: this.contentId,
      contentValidFrom: this.validFrom,
      contentValidTo: this.validTo,
      contentValidInRange: this.validInRange,
      contentStatus: this.status,
      contentTitle: this.contentTitle,
      contentCategory: this.contentCategory,
      contentHasChanged: this.hasChanged,
      contentHasAttach: this.hasAttach,
      needJoin: this.needJoin,
      needReply: this.needReply,
      needFile: this.needFile,
    );
  }

  NoticeDomainModel copyWith({
    int? id,
    DateTime? date,
    bool? readStatus,
    String? code,
    int? contentId,
    DateTime? validFrom,
    DateTime? validTo,
    bool? validInRange,
    String? status,
    String? contentTitle,
    String? contentCategory,
    bool? hasChanged,
    bool? hasAttach,
    bool? needJoin,
    bool? needReply,
    bool? needFile,
    List<AttachmentDomainModel>? attachments,
  }) {
    return NoticeDomainModel(
      id: id ?? this.id,
      date: date ?? this.date,
      readStatus: readStatus ?? this.readStatus,
      code: code ?? this.code,
      contentId: contentId ?? this.contentId,
      validFrom: validFrom ?? this.validFrom,
      validTo: validTo ?? this.validTo,
      validInRange: validInRange ?? this.validInRange,
      status: status ?? this.status,
      contentTitle: contentTitle ?? this.contentTitle,
      contentCategory: contentCategory ?? this.contentCategory,
      hasChanged: hasChanged ?? this.hasChanged,
      hasAttach: hasAttach ?? this.hasAttach,
      needJoin: needJoin ?? this.needJoin,
      needReply: needReply ?? this.needReply,
      needFile: needFile ?? this.needFile,
      attachments: attachments ?? this.attachments,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date?.millisecondsSinceEpoch,
      'readStatus': readStatus,
      'code': code,
      'contentId': contentId,
      'validFrom': validFrom?.millisecondsSinceEpoch,
      'validTo': validTo?.millisecondsSinceEpoch,
      'validInRange': validInRange,
      'status': status,
      'contentTitle': contentTitle,
      'contentCategory': contentCategory,
      'hasChanged': hasChanged,
      'hasAttach': hasAttach,
      'needJoin': needJoin,
      'needReply': needReply,
      'needFile': needFile,
      'attachments': attachments?.map((x) => x?.toMap())?.toList(),
    };
  }

  static NoticeDomainModel? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;

    return NoticeDomainModel(
      id: map['id'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      readStatus: map['readStatus'],
      code: map['code'],
      contentId: map['contentId'],
      validFrom: DateTime.fromMillisecondsSinceEpoch(map['validFrom']),
      validTo: DateTime.fromMillisecondsSinceEpoch(map['validTo']),
      validInRange: map['validInRange'],
      status: map['status'],
      contentTitle: map['contentTitle'],
      contentCategory: map['contentCategory'],
      hasChanged: map['hasChanged'],
      hasAttach: map['hasAttach'],
      needJoin: map['needJoin'],
      needReply: map['needReply'],
      needFile: map['needFile'],
      attachments: List<AttachmentDomainModel>.from(
          map['attachments']?.map((x) => AttachmentDomainModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  static NoticeDomainModel? fromJson(String source) =>
      NoticeDomainModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NoticeDomainModel(id: $id, date: $date, readStatus: $readStatus, code: $code, contentId: $contentId, validFrom: $validFrom, validTo: $validTo, validInRange: $validInRange, status: $status, contentTitle: $contentTitle, contentCategory: $contentCategory, hasChanged: $hasChanged, hasAttach: $hasAttach, needJoin: $needJoin, needReply: $needReply, needFile: $needFile, attachments: $attachments)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is NoticeDomainModel &&
        o.id == id &&
        o.date == date &&
        o.readStatus == readStatus &&
        o.code == code &&
        o.contentId == contentId &&
        o.validFrom == validFrom &&
        o.validTo == validTo &&
        o.validInRange == validInRange &&
        o.status == status &&
        o.contentTitle == contentTitle &&
        o.contentCategory == contentCategory &&
        o.hasChanged == hasChanged &&
        o.hasAttach == hasAttach &&
        o.needJoin == needJoin &&
        o.needReply == needReply &&
        o.needFile == needFile &&
        listEquals(o.attachments, attachments);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        date.hashCode ^
        readStatus.hashCode ^
        code.hashCode ^
        contentId.hashCode ^
        validFrom.hashCode ^
        validTo.hashCode ^
        validInRange.hashCode ^
        status.hashCode ^
        contentTitle.hashCode ^
        contentCategory.hashCode ^
        hasChanged.hashCode ^
        hasAttach.hashCode ^
        needJoin.hashCode ^
        needReply.hashCode ^
        needFile.hashCode ^
        attachments.hashCode;
  }
}
