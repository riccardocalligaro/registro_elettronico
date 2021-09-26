import 'dart:io';

import 'package:registro_elettronico/core/data/local/moor_database.dart';

class DidacticsFile {
  int? contentId;
  String? name;
  File? file;

  DidacticsFile({
    this.contentId,
    this.name,
    this.file,
  });

  DidacticsFile.fromLocalModel(DidacticsDownloadedFileLocalModel l) {
    this.contentId = l.contentId;
    this.name = l.name;
    this.file = File(l.path!);
  }

  DidacticsFile copyWith({
    int? contentId,
    String? name,
    File? file,
  }) {
    return DidacticsFile(
      contentId: contentId ?? this.contentId,
      name: name ?? this.name,
      file: file ?? this.file,
    );
  }

  @override
  String toString() =>
      'DidacticsFile(contentId: $contentId, name: $name, file: $file)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is DidacticsFile &&
        o.contentId == contentId &&
        o.name == name &&
        o.file == file;
  }

  @override
  int get hashCode => contentId.hashCode ^ name.hashCode ^ file.hashCode;
}
