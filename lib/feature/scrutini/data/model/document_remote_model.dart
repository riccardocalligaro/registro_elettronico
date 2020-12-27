class DocumentsResponse {
  List<DocumentRemoteModel> documents;
  List<SchoolReportRemoteModel> schoolReports;

  DocumentsResponse({this.documents, this.schoolReports});

  DocumentsResponse.fromJson(Map<String, dynamic> json) {
    if (json['documents'] != null) {
      documents = new List<DocumentRemoteModel>();
      json['documents'].forEach((v) {
        documents.add(new DocumentRemoteModel.fromJson(v));
      });
    }
    if (json['schoolReports'] != null) {
      schoolReports = new List<SchoolReportRemoteModel>();
      json['schoolReports'].forEach((v) {
        schoolReports.add(new SchoolReportRemoteModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.documents != null) {
      data['documents'] = this.documents.map((v) => v.toJson()).toList();
    }
    if (this.schoolReports != null) {
      data['schoolReports'] =
          this.schoolReports.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DocumentRemoteModel {
  String hash;
  String desc;

  DocumentRemoteModel({this.hash, this.desc});

  DocumentRemoteModel.fromJson(Map<String, dynamic> json) {
    hash = json['hash'];
    desc = json['desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hash'] = this.hash;
    data['desc'] = this.desc;
    return data;
  }
}

class SchoolReportRemoteModel {
  String desc;
  String confirmLink;
  String viewLink;

  SchoolReportRemoteModel({this.desc, this.confirmLink, this.viewLink});

  SchoolReportRemoteModel.fromJson(Map<String, dynamic> json) {
    desc = json['desc'];
    confirmLink = json['confirmLink'];
    viewLink = json['viewLink'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['desc'] = this.desc;
    data['confirmLink'] = this.confirmLink;
    data['viewLink'] = this.viewLink;
    return data;
  }
}
