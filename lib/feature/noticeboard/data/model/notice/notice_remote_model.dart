import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/feature/noticeboard/data/model/attachment/attachment_remote_model.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:registro_elettronico/utils/global_utils.dart';

class NoticeRemoteModel {
  int pubId;
  String pubDT;
  bool readStatus;
  String evtCode;
  int cntId;
  String cntValidFrom;
  String cntValidTo;
  bool cntValidInRange;
  String cntStatus;
  String cntTitle;
  String cntCategory;
  bool cntHasChanged;
  bool cntHasAttach;
  bool needJoin;
  bool needReply;
  bool needFile;
  List<AttachmentRemoteModel> attachments;

  NoticeRemoteModel({
    this.pubId,
    this.pubDT,
    this.readStatus,
    this.evtCode,
    this.cntId,
    this.cntValidFrom,
    this.cntValidTo,
    this.cntValidInRange,
    this.cntStatus,
    this.cntTitle,
    this.cntCategory,
    this.cntHasChanged,
    this.cntHasAttach,
    this.needJoin,
    this.needReply,
    this.needFile,
    this.attachments,
  });

  NoticeLocalModel toLocalModel() {
    return NoticeLocalModel(
      pubId: this.pubId ?? GlobalUtils.getRandomNumber(),
      pubDate: DateTime.tryParse(this.pubDT) ?? DateTime.now(),
      readStatus: this.readStatus ?? false,
      eventCode: this.evtCode ?? "CF",
      contentId: this.cntId ?? GlobalUtils.getRandomNumber(),
      contentValidFrom: DateUtils.getDateFromApiString(this.cntValidFrom),
      contentValidTo: DateUtils.getDateFromApiString(this.cntValidTo),
      contentValidInRange: this.cntValidInRange ?? true,
      contentStatus: this.cntStatus ?? "active",
      contentTitle: this.cntTitle ?? "😶",
      contentCategory: this.cntCategory ?? "😶",
      contentHasAttach: this.cntHasAttach ?? false,
      contentHasChanged: this.cntHasChanged ?? false,
      needJoin: this.needJoin ?? false,
      needReply: this.needReply ?? false,
      needFile: this.needFile ?? false,
    );
  }

  NoticeRemoteModel.fromJson(Map<String, dynamic> json) {
    pubId = json['pubId'];
    pubDT = json['pubDT'];
    readStatus = json['readStatus'];
    evtCode = json['evtCode'];
    cntId = json['cntId'];
    cntValidFrom = json['cntValidFrom'];
    cntValidTo = json['cntValidTo'];
    cntValidInRange = json['cntValidInRange'];
    cntStatus = json['cntStatus'];
    cntTitle = json['cntTitle'];
    cntCategory = json['cntCategory'];
    cntHasChanged = json['cntHasChanged'];
    cntHasAttach = json['cntHasAttach'];
    needJoin = json['needJoin'];
    needReply = json['needReply'];
    needFile = json['needFile'];

    if (json['attachments'] != null) {
      attachments = List<AttachmentRemoteModel>();
      json['attachments'].forEach((v) {
        attachments.add(AttachmentRemoteModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['pubId'] = this.pubId;
    data['pubDT'] = this.pubDT;
    data['readStatus'] = this.readStatus;
    data['evtCode'] = this.evtCode;
    data['cntId'] = this.cntId;
    data['cntValidFrom'] = this.cntValidFrom;
    data['cntValidTo'] = this.cntValidTo;
    data['cntValidInRange'] = this.cntValidInRange;
    data['cntStatus'] = this.cntStatus;
    data['cntTitle'] = this.cntTitle;
    data['cntCategory'] = this.cntCategory;
    data['cntHasChanged'] = this.cntHasChanged;
    data['cntHasAttach'] = this.cntHasAttach;
    data['needJoin'] = this.needJoin;
    data['needReply'] = this.needReply;
    data['needFile'] = this.needFile;
    //data['evento_id'] = this.eventoId;
    if (this.attachments != null) {
      data['attachments'] = this.attachments.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
