part of 'notices_bloc.dart';

@immutable
abstract class NoticesState {}

class NoticesInitial extends NoticesState {}

class NoticesUpdateLoading extends NoticesState {}

class NoticesUpdateLoaded extends NoticesState {}

class NoticesLoadNotConnected extends NoticesState {}

class NoticesUpdateError extends NoticesState {
  final String error;

  NoticesUpdateError(this.error);
}

/// Notices
class NoticesLoading extends NoticesState {}

class NoticesLoaded extends NoticesState {
  final List<Notice> notices;

  NoticesLoaded(this.notices);
}

class NoticesError extends NoticesState {
  final String error;

  NoticesError(this.error);
}
