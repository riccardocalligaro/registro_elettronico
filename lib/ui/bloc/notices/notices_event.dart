import 'package:equatable/equatable.dart';

abstract class NoticesEvent extends Equatable {
  const NoticesEvent();

  @override
  List<Object> get props => [];
}

class FetchNoticeboard extends NoticesEvent {}

class GetNoticeboard extends NoticesEvent {}
