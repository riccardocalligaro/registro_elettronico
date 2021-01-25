class URLContentRemoteModel {
  URLItem item;

  URLContentRemoteModel({this.item});

  URLContentRemoteModel.fromJson(Map<String, dynamic> json) {
    item = json['item'] != null ? URLItem.fromJson(json['item']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.item != null) {
      data['item'] = this.item.toJson();
    }
    return data;
  }
}

class URLItem {
  String link;

  URLItem({this.link});

  URLItem.fromJson(Map<String, dynamic> json) {
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['link'] = this.link;
    return data;
  }
}
