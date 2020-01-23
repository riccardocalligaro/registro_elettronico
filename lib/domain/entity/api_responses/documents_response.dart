class DocumentsResponse {
  List<ApiDocument> documents;
  List<ApiSchoolReport> schoolReports;

  DocumentsResponse({this.documents, this.schoolReports});

  DocumentsResponse.fromJson(Map<String, dynamic> json) {
    if (json['documents'] != null) {
      documents = new List<ApiDocument>();
      json['documents'].forEach((v) {
        documents.add(new ApiDocument.fromJson(v));
      });
    }
    if (json['schoolReports'] != null) {
      schoolReports = new List<ApiSchoolReport>();
      json['schoolReports'].forEach((v) {
        schoolReports.add(new ApiSchoolReport.fromJson(v));
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

class ApiDocument {
  String hash;
  String desc;

  ApiDocument({this.hash, this.desc});

  ApiDocument.fromJson(Map<String, dynamic> json) {
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

class ApiSchoolReport {
  String desc;
  String confirmLink;
  String viewLink;

  ApiSchoolReport({this.desc, this.confirmLink, this.viewLink});

  ApiSchoolReport.fromJson(Map<String, dynamic> json) {
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
