class ParentsLoginResponse {
  String requestedAction;
  List<Choices> choices;
  String message;

  ParentsLoginResponse({this.requestedAction, this.choices, this.message});

  ParentsLoginResponse.fromJson(Map<String, dynamic> json) {
    requestedAction = json['requestedAction'];
    if (json['choices'] != null) {
      choices = List<Choices>();
      json['choices'].forEach((v) {
        choices.add(Choices.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['requestedAction'] = this.requestedAction;
    if (this.choices != null) {
      data['choices'] = this.choices.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Choices {
  String cid;
  String ident;
  String name;
  String school;

  Choices({this.cid, this.ident, this.name, this.school});

  Choices.fromJson(Map<String, dynamic> json) {
    cid = json['cid'];
    ident = json['ident'];
    name = json['name'];
    school = json['school'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['cid'] = this.cid;
    data['ident'] = this.ident;
    data['name'] = this.name;
    data['school'] = this.school;
    return data;
  }
}
