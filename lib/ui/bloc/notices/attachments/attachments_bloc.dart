import 'dart:async';
import 'package:bloc/bloc.dart';
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
      try {
        final attachments =
            await noticesRepository.getAttachmentsForPubId(event.notice.pubId);
        yield NoticesAttachmentsLoaded(attachments);
      } catch (e) {
        yield NoticesAttachmentsError(e.toString());
      }
    }
  }
}
