import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';

abstract class DidacticsAttachmentsEvent extends Equatable {
  const DidacticsAttachmentsEvent();

  @override
  List<Object> get props => null;
}

class GetAttachment extends DidacticsAttachmentsEvent {
  final DidacticsContent content;

  GetAttachment({
    @required this.content,
  });
}
