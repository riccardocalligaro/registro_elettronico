class NoticeboardResponse {
  List<NoticeRemoteModel> items;

  NoticeboardResponse({this.items});

  NoticeboardResponse.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = new List<NoticeRemoteModel>();
      json['items'].forEach((v) {
        items.add(new NoticeRemoteModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

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

  NoticeRemoteModel(
      {this.pubId,
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
      //this.eventoId,
      this.attachments});

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
    //eventoId = json['evento_id'] ?? json['pubId'].toString();
    if (json['attachments'] != null) {
      attachments = new List<AttachmentRemoteModel>();
      json['attachments'].forEach((v) {
        attachments.add(new AttachmentRemoteModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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

class AttachmentRemoteModel {
  String fileName;
  int attachNum;

  AttachmentRemoteModel({this.fileName, this.attachNum});

  AttachmentRemoteModel.fromJson(Map<String, dynamic> json) {
    fileName = json['fileName'];
    attachNum = json['attachNum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fileName'] = this.fileName;
    data['attachNum'] = this.attachNum;
    return data;
  }
}
