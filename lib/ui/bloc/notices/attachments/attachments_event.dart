import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';

abstract class AttachmentsEvent extends Equatable {
  const AttachmentsEvent();

  @override
  List<Object> get props => [];
}

class GetAttachments extends AttachmentsEvent {
  final Notice notice;

  GetAttachments({
    @required this.notice,
  });
}
