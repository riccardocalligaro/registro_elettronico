import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:f_logs/f_logs.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injector/injector.dart';
import 'package:registro_elettronico/core/error/failures.dart';
import 'package:registro_elettronico/domain/repository/notices_repository.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    FLog.info(text: event.toString());
    if (event is FetchNoticeboard) {
      yield NoticesUpdateLoading();
      FLog.info(text: 'Updating noticeboard');
      try {
        await noticesRepository.updateNotices();
        SharedPreferences prefs = Injector.appInstance.getDependency();
        prefs.setInt(PrefsConstants.LAST_UPDATE_NOTICEBOARD,
            DateTime.now().millisecondsSinceEpoch);
        yield NoticesUpdateLoaded();
      } on NotConntectedException {
        yield NoticesLoadNotConnected();
      } on DioError catch (e, s) {
        FLog.error(
          text: 'Network Error fetching noticeboardd',
          exception: e,
          stacktrace: s,
        );
        yield NoticesUpdateError(e.response.data.toString());
      } on Exception catch (e, s) {
        FLog.error(
          text: 'Error when updating noticeboard',
          exception: e,
          stacktrace: s,
        );
        Crashlytics.instance.recordError(e, s);

        yield NoticesUpdateError(e.toString());
      }
    }

    if (event is GetNoticeboard) {
      yield NoticesLoading();
      FLog.info(text: 'Getting noticeboard');
      try {
        final notices = await noticesRepository.getAllNotices();
        FLog.info(text: 'BloC -> Got ${notices.length} notices');
        yield NoticesLoaded(notices);
      } on Exception catch (e, s) {
        FLog.error(
          text: 'Error getting lessons by date',
          exception: e,
          stacktrace: s,
        );
        Crashlytics.instance.recordError(e, s);

        yield NoticesError(e.toString());
      }
    }
  }
}
