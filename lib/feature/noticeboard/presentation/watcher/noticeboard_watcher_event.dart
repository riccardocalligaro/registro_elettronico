part of 'noticeboard_watcher_bloc.dart';

@immutable
abstract class NoticeboardWatcherEvent {}

class NoticeboardDataReceived extends NoticeboardWatcherEvent {
  final Resource<List<NoticeDomainModel>> resource;

  NoticeboardDataReceived({
    @required this.resource,
  });
}
