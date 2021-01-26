import 'package:registro_elettronico/core/data/local/moor_database.dart';

class AttachmentRemoteModel {
  String fileName;
  int attachNum;

  AttachmentRemoteModel({this.fileName, this.attachNum});

  AttachmentRemoteModel.fromJson(Map<String, dynamic> json) {
    fileName = json['fileName'];
    attachNum = json['attachNum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['fileName'] = this.fileName;
    data['attachNum'] = this.attachNum;
    return data;
  }

  NoticeAttachmentLocalModel toLocalModel(int pubId) {
    return NoticeAttachmentLocalModel(
      id: null,
      pubId: pubId ?? -1,
      fileName: this.fileName ?? 'attachment',
      attachNumber: this.attachNum ?? -1,
    );
  }
}
