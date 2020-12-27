class DidacticsResponse {
  List<TeacherRemoteModel> teachers;

  DidacticsResponse({this.teachers});

  DidacticsResponse.fromJson(Map<String, dynamic> json) {
    if (json['didacticts'] != null) {
      teachers = List<TeacherRemoteModel>();
      json['didacticts'].forEach((v) {
        teachers.add(TeacherRemoteModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.teachers != null) {
      data['didacticts'] = this.teachers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TeacherRemoteModel {
  String teacherId;
  String teacherName;
  String teacherFirstName;
  String teacherLastName;
  List<FolderRemoteModel> folders;

  TeacherRemoteModel(
      {this.teacherId,
      this.teacherName,
      this.teacherFirstName,
      this.teacherLastName,
      this.folders});

  TeacherRemoteModel.fromJson(Map<String, dynamic> json) {
    teacherId = json['teacherId'];
    teacherName = json['teacherName'];
    teacherFirstName = json['teacherFirstName'];
    teacherLastName = json['teacherLastName'];
    if (json['folders'] != null) {
      folders = List<FolderRemoteModel>();
      json['folders'].forEach((v) {
        folders.add(FolderRemoteModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['teacherId'] = this.teacherId;
    data['teacherName'] = this.teacherName;
    data['teacherFirstName'] = this.teacherFirstName;
    data['teacherLastName'] = this.teacherLastName;
    if (this.folders != null) {
      data['folders'] = this.folders.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FolderRemoteModel {
  int folderId;
  String folderName;
  String lastShareDT;
  List<ContentRemoteModel> contents;

  FolderRemoteModel(
      {this.folderId, this.folderName, this.lastShareDT, this.contents});

  FolderRemoteModel.fromJson(Map<String, dynamic> json) {
    folderId = json['folderId'];
    folderName = json['folderName'];
    lastShareDT = json['lastShareDT'];
    if (json['contents'] != null) {
      contents = List<ContentRemoteModel>();
      json['contents'].forEach((v) {
        contents.add(ContentRemoteModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['folderId'] = this.folderId;
    data['folderName'] = this.folderName;
    data['lastShareDT'] = this.lastShareDT;
    if (this.contents != null) {
      data['contents'] = this.contents.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ContentRemoteModel {
  int contentId;
  String contentName;
  int objectId;
  String objectType;
  String shareDT;

  ContentRemoteModel(
      {this.contentId,
      this.contentName,
      this.objectId,
      this.objectType,
      this.shareDT});

  ContentRemoteModel.fromJson(Map<String, dynamic> json) {
    contentId = json['contentId'];
    contentName = json['contentName'];
    objectId = json['objectId'];
    objectType = json['objectType'];
    shareDT = json['shareDT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['contentId'] = this.contentId;
    data['contentName'] = this.contentName;
    data['objectId'] = this.objectId;
    data['objectType'] = this.objectType;
    data['shareDT'] = this.shareDT;
    return data;
  }
}

class DownloadAttachmentURLResponse {
  Item item;

  DownloadAttachmentURLResponse({this.item});

  DownloadAttachmentURLResponse.fromJson(Map<String, dynamic> json) {
    item = json['item'] != null ? Item.fromJson(json['item']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.item != null) {
      data['item'] = this.item.toJson();
    }
    return data;
  }
}

class Item {
  String link;

  Item({this.link});

  Item.fromJson(Map<String, dynamic> json) {
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['link'] = this.link;
    return data;
  }
}

class DownloadAttachmentTextResponse {
  String text;

  DownloadAttachmentTextResponse({this.text});

  DownloadAttachmentTextResponse.fromJson(Map<String, dynamic> json) {
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
