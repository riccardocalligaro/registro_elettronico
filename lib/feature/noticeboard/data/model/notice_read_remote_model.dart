class NoticeboardReadResponse {
  NoticeReadRemoteModel item;

  NoticeboardReadResponse({this.item});

  NoticeboardReadResponse.fromJson(Map<String, dynamic> json) {
    item = json['item'] != null ? new NoticeReadRemoteModel.fromJson(json['item']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.item != null) {
      data['item'] = this.item.toJson();
    }
    return data;
  }
}

class NoticeReadRemoteModel {
  String title;
  String text;

  NoticeReadRemoteModel({this.title, this.text});

  NoticeReadRemoteModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['text'] = this.text;
    return data;
  }
}
