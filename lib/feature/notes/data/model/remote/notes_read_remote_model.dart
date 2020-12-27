class NotesReadResponse {
  NoteEvent event;

  NotesReadResponse({this.event});

  NotesReadResponse.fromJson(Map<String, dynamic> json) {
    event = json['event'] != null ? NoteEvent.fromJson(json['event']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.event != null) {
      data['event'] = this.event.toJson();
    }
    return data;
  }
}

class NoteEvent {
  String evtCode;
  int evtId;
  String evtText;

  NoteEvent({this.evtCode, this.evtId, this.evtText});

  NoteEvent.fromJson(Map<String, dynamic> json) {
    evtCode = json['evtCode'];
    evtId = json['evtId'];
    evtText = json['evtText'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['evtCode'] = this.evtCode;
    data['evtId'] = this.evtId;
    data['evtText'] = this.evtText;
    return data;
  }
}
