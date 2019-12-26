class DidacticsResponse {
  List<Teacher> teachers;

  DidacticsResponse({this.teachers});

  DidacticsResponse.fromJson(Map<String, dynamic> json) {
    if (json['didacticts'] != null) {
      teachers = new List<Teacher>();
      json['didacticts'].forEach((v) {
        teachers.add(new Teacher.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.teachers != null) {
      data['didacticts'] = this.teachers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Teacher {
  String teacherId;
  String teacherName;
  String teacherFirstName;
  String teacherLastName;
  List<Folder> folders;

  Teacher(
      {this.teacherId,
      this.teacherName,
      this.teacherFirstName,
      this.teacherLastName,
      this.folders});

  Teacher.fromJson(Map<String, dynamic> json) {
    teacherId = json['teacherId'];
    teacherName = json['teacherName'];
    teacherFirstName = json['teacherFirstName'];
    teacherLastName = json['teacherLastName'];
    if (json['folders'] != null) {
      folders = new List<Folder>();
      json['folders'].forEach((v) {
        folders.add(new Folder.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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

class Folder {
  int folderId;
  String folderName;
  String lastShareDT;
  List<Content> contents;

  Folder({this.folderId, this.folderName, this.lastShareDT, this.contents});

  Folder.fromJson(Map<String, dynamic> json) {
    folderId = json['folderId'];
    folderName = json['folderName'];
    lastShareDT = json['lastShareDT'];
    if (json['contents'] != null) {
      contents = new List<Content>();
      json['contents'].forEach((v) {
        contents.add(new Content.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['folderId'] = this.folderId;
    data['folderName'] = this.folderName;
    data['lastShareDT'] = this.lastShareDT;
    if (this.contents != null) {
      data['contents'] = this.contents.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Content {
  int contentId;
  String contentName;
  int objectId;
  String objectType;
  String shareDT;

  Content(
      {this.contentId,
      this.contentName,
      this.objectId,
      this.objectType,
      this.shareDT});

  Content.fromJson(Map<String, dynamic> json) {
    contentId = json['contentId'];
    contentName = json['contentName'];
    objectId = json['objectId'];
    objectType = json['objectType'];
    shareDT = json['shareDT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contentId'] = this.contentId;
    data['contentName'] = this.contentName;
    data['objectId'] = this.objectId;
    data['objectType'] = this.objectType;
    data['shareDT'] = this.shareDT;
    return data;
  }
}

class DownloadAttachmentURLResponse {
  String item;

  DownloadAttachmentURLResponse({this.item});

  DownloadAttachmentURLResponse.fromJson(Map<String, dynamic> json) {
    item = json['item'] != null ? json['item'] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.item != null) {
      data['item'] = this.item;
    }
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.text != null) {
      data['text'] = this.text;
    }
    return data;
  }
}
