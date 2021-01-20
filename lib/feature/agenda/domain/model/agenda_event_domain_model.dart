import 'dart:convert';

import 'package:registro_elettronico/core/data/local/moor_database.dart';

class AgendaEventDomainModel {
  int id;
  String code;
  DateTime begin;
  DateTime end;
  bool isFullDay;
  String notes;
  String author;
  String className;
  int subjectId;
  String subjectName;
  bool isLocal;
  String labelColor;
  String title;

  AgendaEventDomainModel({
    this.id,
    this.code,
    this.begin,
    this.end,
    this.isFullDay,
    this.notes,
    this.author,
    this.className,
    this.subjectId,
    this.subjectName,
    this.isLocal,
    this.labelColor,
    this.title,
  });

  AgendaEventDomainModel.fromLocalModel(AgendaEventLocalModel l) {
    this.id = l.evtId;
    this.code = l.evtCode;
    this.begin = l.begin;
    this.end = l.end;
    this.isFullDay = l.isFullDay;
    this.notes = l.notes;
    this.author = l.authorName;
    this.className = l.classDesc;
    this.subjectId = l.subjectId;
    this.subjectName = l.subjectDesc;
    this.isLocal = l.isLocal;
    this.labelColor = l.labelColor;
    this.title = l.title;
  }

  AgendaEventLocalModel toLocalModel() {
    return AgendaEventLocalModel(
      evtId: this.id,
      evtCode: this.code,
      begin: this.begin,
      end: this.end,
      isFullDay: this.isFullDay,
      notes: this.notes,
      authorName: this.author,
      classDesc: this.className,
      subjectId: this.subjectId,
      subjectDesc: this.subjectName,
      isLocal: this.isLocal,
      labelColor: this.labelColor,
      title: this.title,
    );
  }
}
