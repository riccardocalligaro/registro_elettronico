class NotesResponse {
  List<NoteRemoteModel> notesNTTE;
  List<NoteRemoteModel> notesNTCL;
  List<NoteRemoteModel> notesNTWN;
  List<NoteRemoteModel> notesNTST;

  NotesResponse({
    this.notesNTTE,
    this.notesNTCL,
    this.notesNTWN,
    this.notesNTST,
  });

  NotesResponse.fromJson(Map<String, dynamic> json) {
    if (json['NTTE'] != null) {
      notesNTTE = List<NoteRemoteModel>();
      json['NTTE'].forEach((v) {
        notesNTTE.add(NoteRemoteModel.fromJson(v));
      });
    }
    if (json['NTCL'] != null) {
      notesNTCL = List<NoteRemoteModel>();
      json['NTCL'].forEach((v) {
        notesNTCL.add(NoteRemoteModel.fromJson(v));
      });
    }
    if (json['NTWN'] != null) {
      notesNTWN = List<NoteRemoteModel>();
      json['NTWN'].forEach((v) {
        notesNTWN.add(NoteRemoteModel.fromJson(v));
      });
    }
    if (json['NTST'] != null) {
      notesNTST = List<NoteRemoteModel>();
      json['NTST'].forEach((v) {
        notesNTST.add(NoteRemoteModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.notesNTTE != null) {
      data['NTTE'] = this.notesNTTE.map((v) => v.toJson()).toList();
    }
    if (this.notesNTCL != null) {
      data['NTCL'] = this.notesNTCL.map((v) => v.toJson()).toList();
    }
    if (this.notesNTWN != null) {
      data['NTWN'] = this.notesNTWN.map((v) => v.toJson()).toList();
    }
    if (this.notesNTST != null) {
      data['NTST'] = this.notesNTST.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NoteRemoteModel {
  String authorName;
  String evtDate;
  int evtId;
  bool readStatus;
  String extText;
  String warningType;

  NoteRemoteModel(
      {this.authorName,
      this.evtDate,
      this.evtId,
      this.readStatus,
      this.extText,
      this.warningType});

  NoteRemoteModel.fromJson(Map<String, dynamic> json) {
    authorName = json['authorName'];
    evtDate = json['evtDate'];
    evtId = json['evtId'];
    readStatus = json['readStatus'];
    extText = json['extText'];
    warningType = json['warningType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['authorName'] = this.authorName;
    data['evtDate'] = this.evtDate;
    data['evtId'] = this.evtId;
    data['readStatus'] = this.readStatus;
    data['extText'] = this.extText;
    data['warningType'] = this.warningType;
    return data;
  }
}
