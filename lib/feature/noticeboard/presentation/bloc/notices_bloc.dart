import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:registro_elettronico/core/infrastructure/log/logger.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:meta/meta.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures.dart';
import 'package:registro_elettronico/feature/noticeboard/domain/repository/notices_repository.dart';

part 'notices_event.dart';
part 'notices_state.dart';

class NoticesBloc extends Bloc<NoticesEvent, NoticesState> {
  final NoticesRepository noticesRepository;

  NoticesBloc({
    @required this.noticesRepository,
  }) : super(NoticesInitial());

  @override
  Stream<NoticesState> mapEventToState(
    NoticesEvent event,
  ) async* {
    Logger.info(event.toString());
    if (event is FetchNoticeboard) {
      yield NoticesUpdateLoading();
      Logger.info('Updating noticeboard');
      try {
        await noticesRepository.updateNotices();

        yield NoticesUpdateLoaded();
      } on NotConntectedException {
        yield NoticesLoadNotConnected();
      } on DioError catch (e, s) {
        Logger.e(
          text: 'Network Error fetching noticeboardd',
          exception: e,
          stacktrace: s,
        );
        yield NoticesUpdateError(e.response.data.toString());
      } on Exception catch (e, s) {
        Logger.e(
          text: 'Error when updating noticeboard',
          exception: e,
          stacktrace: s,
        );
        await FirebaseCrashlytics.instance.recordError(e, s);

        yield NoticesUpdateError(e.toString());
      }
    }

    if (event is GetNoticeboard) {
      yield NoticesLoading();
      Logger.info('Getting noticeboard');
      try {
        final notices = await noticesRepository.getAllNotices();
        Logger.info('BloC -> Got ${notices.length} notices');
        yield NoticesLoaded(notices);
      } on Exception catch (e, s) {
        Logger.e(
          text: 'Error getting lessons by date',
          exception: e,
          stacktrace: s,
        );
        await FirebaseCrashlytics.instance.recordError(e, s);

        yield NoticesError(e.toString());
      }
    }
  }
}
