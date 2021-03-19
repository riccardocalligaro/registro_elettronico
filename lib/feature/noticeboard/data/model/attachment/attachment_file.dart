import 'dart:io';

class GenericAttachment {}

class AttachmentFile extends GenericAttachment {
  final File file;

  AttachmentFile(this.file);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AttachmentFile && other.file == file;
  }

  @override
  int get hashCode => file.hashCode;
}

class AttachmentText extends GenericAttachment {
  final String text;

  AttachmentText(this.text);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AttachmentText && other.text == text;
  }

  @override
  int get hashCode => text.hashCode;
}
