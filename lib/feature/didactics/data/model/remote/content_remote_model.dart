import 'package:registro_elettronico/core/data/local/moor_database.dart';

class ContentRemoteModel {
  int? contentId;
  String? contentName;
  int? objectId;
  String? objectType;
  String? shareDT;

  ContentRemoteModel({
    this.contentId,
    this.contentName,
    this.objectId,
    this.objectType,
    this.shareDT,
  });

  ContentLocalModel toLocalModel({required int? folderId}) {
    return ContentLocalModel(
      folderId: folderId ?? -1,
      id: this.contentId ?? -1,
      name: this.contentName ?? '',
      objectId: this.objectId! - 1,
      type: this.objectType ?? -1 as String?,
      date: DateTime.tryParse(this.shareDT!) ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  ContentRemoteModel.fromJson(Map<String, dynamic> json) {
    contentId = json['contentId'];
    contentName = json['contentName'];
    objectId = json['objectId'];
    objectType = json['objectType'];
    shareDT = json['shareDT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['contentId'] = this.contentId;
    data['contentName'] = this.contentName;
    data['objectId'] = this.objectId;
    data['objectType'] = this.objectType;
    data['shareDT'] = this.shareDT;
    return data;
  }
}
