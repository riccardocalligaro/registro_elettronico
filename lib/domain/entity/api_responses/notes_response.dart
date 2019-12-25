class NotesResponse {
  List<Note> notesNTTE;
  List<Note> notesNTCL;
  List<Note> notesNTWN;
  List<Note> notesNTST;

  NotesResponse({
    this.notesNTTE,
    this.notesNTCL,
    this.notesNTWN,
    this.notesNTST,
  });

  NotesResponse.fromJson(Map<String, dynamic> json) {
    if (json['NTTE'] != null) {
      notesNTTE = new List<Note>();
      json['NTTE'].forEach((v) {
        notesNTTE.add(new Note.fromJson(v));
      });
    }
    if (json['NTCL'] != null) {
      notesNTCL = new List<Note>();
      json['NTCL'].forEach((v) {
        notesNTCL.add(new Note.fromJson(v));
      });
    }
    if (json['NTWN'] != null) {
      notesNTWN = new List<Note>();
      json['NTWN'].forEach((v) {
        notesNTWN.add(new Note.fromJson(v));
      });
    }
    if (json['NTST'] != null) {
      notesNTST = new List<Note>();
      json['NTST'].forEach((v) {
        notesNTST.add(new Note.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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

class Note {
  String authorName;
  String evtDate;
  int evtId;
  bool readStatus;
  String extText;
  String warningType;

  Note(
      {this.authorName,
      this.evtDate,
      this.evtId,
      this.readStatus,
      this.extText,
      this.warningType});

  Note.fromJson(Map<String, dynamic> json) {
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
