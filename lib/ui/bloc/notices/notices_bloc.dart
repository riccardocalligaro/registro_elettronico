import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:f_logs/f_logs.dart';
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
      try {
        await noticesRepository.updateNotices();
        final prefs = await SharedPreferences.getInstance();
        prefs.setInt(PrefsConstants.LAST_UPDATE_NOTICEBOARD,
            DateTime.now().millisecondsSinceEpoch);
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
  }
}
