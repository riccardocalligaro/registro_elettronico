import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AttachmentDownloadEvent extends Equatable {
  const AttachmentDownloadEvent();

  @override
  List<Object> get props => [];
}

class DownloadAttachment extends AttachmentDownloadEvent {
  final int pubId;
  final int attachmentNumber;

  DownloadAttachment({
    @required this.pubId,
    @required this.attachmentNumber,
  });
}
