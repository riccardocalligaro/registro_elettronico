part of 'notices_bloc.dart';

@immutable
abstract class NoticesEvent {}

class FetchNoticeboard extends NoticesEvent {}

class GetNoticeboard extends NoticesEvent {}
