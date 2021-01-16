import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:registro_elettronico/core/infrastructure/log/logger.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:meta/meta.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures.dart';
import 'package:registro_elettronico/feature/noticeboard/domain/repository/notices_repository.dart';

part 'attachments_event.dart';
part 'attachments_state.dart';

class AttachmentsBloc extends Bloc<AttachmentsEvent, AttachmentsState> {
  final NoticesRepository noticesRepository;

  AttachmentsBloc({
    @required this.noticesRepository,
  }) : super(AttachmentsInitial());

  @override
  Stream<AttachmentsState> mapEventToState(
    AttachmentsEvent event,
  ) async* {
    if (event is GetAttachments) {
      yield NoticesAttachmentsLoading();
      Logger.info('Getting attachment for ${event.notice.pubId}');
      try {
        final attachments =
            await noticesRepository.getAttachmentsForPubId(event.notice.pubId);
        yield NoticesAttachmentsLoaded(attachments);
      } on NotConntectedException {
        yield NoticesAttachmentsLoadNotConnected();
      } catch (e, s) {
        Logger.e(
          text: 'Error getting attachments for notice',
          exception: e,
          stacktrace: s,
        );
        await FirebaseCrashlytics.instance.recordError(e, s);
        yield NoticesAttachmentsError(e.toString());
      }
    }
  }
}
