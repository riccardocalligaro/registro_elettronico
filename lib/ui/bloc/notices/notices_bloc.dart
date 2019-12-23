import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:registro_elettronico/domain/repository/notices_repository.dart';
import './bloc.dart';

class NoticesBloc extends Bloc<NoticesEvent, NoticesState> {
  NoticesRepository noticesRepository;

  NoticesBloc(this.noticesRepository);

  @override
  NoticesState get initialState => NoticesInitial();

  @override
  Stream<NoticesState> mapEventToState(
    NoticesEvent event,
  ) async* {
    if (event is FetchNoticeboard) {
      yield NoticesUpdateLoading();
      try {
        await noticesRepository.updateNotices();
        yield NoticesUpdateLoaded();
      } on DioError catch (e) {
        yield NoticesUpdateError(e.response.data.toString());
      } catch (e) {
        yield NoticesUpdateError(e.toString());
      }
    }

    if (event is GetNoticeboard) {
      yield NoticesLoading();
      try {
        final notices = await noticesRepository.getAllNotices();
        yield NoticesLoaded(notices);
      } catch (e) {
        yield NoticesError(e.toString());
      }
    }

    if (event is GetAttachments) {
      yield NoticesAttachmentsLoading();
      try {
        final attachments =
            await noticesRepository.getAttachmentsForPubId(event.pubId);
        yield NoticesAttachmentsLoaded(attachments);
      } catch (e) {
        yield NoticesAttachmentsError(e.toString());
      }
    }

  }
}
