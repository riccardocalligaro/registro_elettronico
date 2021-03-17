import 'package:flutter/foundation.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';

import 'content_remote_model.dart';

class FolderRemoteModel {
  int folderId;
  String folderName;
  String lastShareDT;
  List<ContentRemoteModel> contents;

  FolderRemoteModel({
    this.folderId,
    this.folderName,
    this.lastShareDT,
    this.contents,
  });

  FolderLocalModel toLocalModel({
    @required teacherId,
  }) {
    return FolderLocalModel(
      teacherId: teacherId ?? '',
      id: this.folderId ?? -1,
      name: this.folderName ?? -1,
      lastShare: DateTime.tryParse(this.lastShareDT) ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  FolderRemoteModel.fromJson(Map<String, dynamic> json) {
    folderId = json['folderId'];
    folderName = json['folderName'];
    lastShareDT = json['lastShareDT'];
    if (json['contents'] != null) {
      contents = <ContentRemoteModel>[];
      json['contents'].forEach((v) {
        contents.add(ContentRemoteModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['folderId'] = this.folderId;
    data['folderName'] = this.folderName;
    data['lastShareDT'] = this.lastShareDT;
    if (this.contents != null) {
      data['contents'] = this.contents.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
