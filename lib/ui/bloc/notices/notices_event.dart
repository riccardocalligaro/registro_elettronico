import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class NoticesEvent extends Equatable {
  const NoticesEvent();

  @override
  List<Object> get props => [];
}

class FetchNoticeboard extends NoticesEvent {}

class GetNoticeboard extends NoticesEvent {}

class GetAttachments extends NoticesEvent {
  final int pubId;

  GetAttachments({
    @required this.pubId,
  });
}
