class TextContentRemoteModel {
  String text;

  TextContentRemoteModel({this.text});

  TextContentRemoteModel.fromJson(Map<String, dynamic> json) {
    text = json['text'] != null ? json['text'] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.text != null) {
      data['text'] = this.text;
    }
    return data;
  }
}
