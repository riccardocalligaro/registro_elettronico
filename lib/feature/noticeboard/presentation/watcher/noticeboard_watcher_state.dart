part of 'noticeboard_watcher_bloc.dart';

@immutable
abstract class NoticeboardWatcherState {}

class NoticeboardWatcherInitial extends NoticeboardWatcherState {}

class NoticeboardWatcherLoading extends NoticeboardWatcherState {}

class NoticeboardWatcherLoadSuccess extends NoticeboardWatcherState {
  final List<NoticeDomainModel> notices;

  NoticeboardWatcherLoadSuccess({
    @required this.notices,
  });
}

class NoticeboardWatcherFailure extends NoticeboardWatcherState {
  final Failure failure;

  NoticeboardWatcherFailure({@required this.failure});
}
