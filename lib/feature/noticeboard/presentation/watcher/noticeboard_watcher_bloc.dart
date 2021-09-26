import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures_v2.dart';
import 'package:registro_elettronico/core/infrastructure/generic/resource.dart';
import 'package:registro_elettronico/feature/noticeboard/domain/model/notice_domain_model.dart';
import 'package:registro_elettronico/feature/noticeboard/domain/repository/noticeboard_repository.dart';

part 'noticeboard_watcher_event.dart';
part 'noticeboard_watcher_state.dart';

class NoticeboardWatcherBloc
    extends Bloc<NoticeboardWatcherEvent, NoticeboardWatcherState> {
  final NoticeboardRepository noticeboardRepository;

  late StreamSubscription _noticesStreamSubscription;

  NoticeboardWatcherBloc({
    required this.noticeboardRepository,
  }) : super(NoticeboardWatcherInitial()) {
    _noticesStreamSubscription =
        noticeboardRepository.watchAllNotices().listen((resource) {
      add(NoticeboardDataReceived(resource: resource));
    });
  }

  @override
  Stream<NoticeboardWatcherState> mapEventToState(
    NoticeboardWatcherEvent event,
  ) async* {
    if (event is NoticeboardDataReceived) {
      if (event.resource.status == Status.failed) {
        yield NoticeboardWatcherFailure(failure: event.resource.failure);
      } else if (event.resource.status == Status.success) {
        yield NoticeboardWatcherLoadSuccess(
          notices: event.resource.data,
        );
      } else if (event.resource.status == Status.loading) {
        yield NoticeboardWatcherLoading();
      }
    }
  }

  @override
  Future<void> close() {
    _noticesStreamSubscription.cancel();
    return super.close();
  }
}
