import 'package:flutter/material.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';

abstract class DidacticsAttachmentsEvent {
  const DidacticsAttachmentsEvent();
}

class GetAttachment extends DidacticsAttachmentsEvent {
  final DidacticsContent content;

  const GetAttachment({@required this.content});
}

class DeleteAttachment extends DidacticsAttachmentsEvent {
  final DidacticsContent content;
  const DeleteAttachment({@required this.content});
}


