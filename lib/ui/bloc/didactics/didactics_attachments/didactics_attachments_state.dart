import 'package:flutter/material.dart';

abstract class DidacticsAttachmentsState {
  const DidacticsAttachmentsState();
}

class DidacticsAttachmentsInitial extends DidacticsAttachmentsState {}

class DidacticsAttachmentsLoading extends DidacticsAttachmentsState {}

class DidacticsAttachmentsErrorNotConnected extends DidacticsAttachmentsState {}

class DidacticsAttachmentsTextLoaded extends DidacticsAttachmentsState {
  final String text;

  DidacticsAttachmentsTextLoaded({
    @required this.text,
  });
}

class DidacticsAttachmentsFileLoaded extends DidacticsAttachmentsState {
  final String path;

  DidacticsAttachmentsFileLoaded({
    @required this.path,
  });
}

class DidacticsAttachmentsURLLoaded extends DidacticsAttachmentsState {
  final String url;

  DidacticsAttachmentsURLLoaded({
    @required this.url,
  });
}

class DidacticsAttachmentsErrror extends DidacticsAttachmentsState {
  final String error;

  DidacticsAttachmentsErrror({
    @required this.error,
  });
}
