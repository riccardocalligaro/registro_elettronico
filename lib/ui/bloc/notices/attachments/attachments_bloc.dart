import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:registro_elettronico/core/error/failures.dart';
import 'package:registro_elettronico/domain/repository/notices_repository.dart';
import './bloc.dart';

class AttachmentsBloc extends Bloc<AttachmentsEvent, AttachmentsState> {
  NoticesRepository noticesRepository;

  AttachmentsBloc(this.noticesRepository);

  @override
  AttachmentsState get initialState => NoticesAttachmentsInitial();

  @override
  Stream<AttachmentsState> mapEventToState(
    AttachmentsEvent event,
  ) async* {
    if (event is GetAttachments) {
      yield NoticesAttachmentsLoading();
      FLog.info(text: 'Getting attachment for ${event.notice.pubId}');
      try {
        final attachments =
            await noticesRepository.getAttachmentsForPubId(event.notice.pubId);
        yield NoticesAttachmentsLoaded(attachments);
      } on NotConntectedException {
        yield NoticesAttachmentsLoadNotConnected();
      } catch (e, s) {
        FLog.error(
          text: 'Error getting attachments for notice',
          exception: e,
          stacktrace: s,
        );
        Crashlytics.instance.recordError(e, s);
        yield NoticesAttachmentsError(e.toString());
      }
    }
  }
}
