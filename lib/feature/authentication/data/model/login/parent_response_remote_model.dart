class ParentLoginResponseRemoteModel {
  String? requestedAction;
  List<LoginChoiceRemoteModel>? choices;
  String? message;

  ParentLoginResponseRemoteModel({
    this.requestedAction,
    this.choices,
    this.message,
  });

  ParentLoginResponseRemoteModel.fromJson(Map<String, dynamic> json) {
    requestedAction = json['requestedAction'];
    if (json['choices'] != null) {
      choices = [];
      json['choices'].forEach((v) {
        choices!.add(LoginChoiceRemoteModel.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['requestedAction'] = this.requestedAction;
    if (this.choices != null) {
      data['choices'] = this.choices!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class LoginChoiceRemoteModel {
  String? cid;
  String? ident;
  String? name;
  String? school;

  LoginChoiceRemoteModel({
    required this.cid,
    required this.ident,
    required this.name,
    required this.school,
  });

  LoginChoiceRemoteModel.fromJson(Map<String, dynamic> json) {
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
