import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:registro_elettronico/feature/noticeboard/data/repository/noticeboard_repository_impl.dart';
import 'package:registro_elettronico/feature/noticeboard/presentation/attachment/attachment_download_bloc.dart';
import 'package:registro_elettronico/feature/noticeboard/presentation/watcher/noticeboard_watcher_bloc.dart';

import 'data/datasource/noticeboard_local_datasource.dart';
import 'data/datasource/noticeboard_remote_datasource.dart';
import 'data/repository/noticeboard_repository_impl.dart';
import 'domain/repository/noticeboard_repository.dart';

final _sl = GetIt.instance;

class NoticeboardContainer {
  static Future<void> init() async {
    _sl.registerLazySingleton(
      () => NoticeboardLocalDatasource(_sl()),
    );

    _sl.registerLazySingleton(
      () => NoticeboardRemoteDatasource(
        dio: _sl(),
      ),
    );

    _sl.registerLazySingleton<NoticeboardRepository>(
      () => NoticeboardRepositoryImpl(
        noticeboardRemoteDatasource: _sl(),
        noticeboardLocalDatasource: _sl(),
        sharedPreferences: _sl(),
      ),
    );
  }

  static List<BlocProvider> getBlocProviders() {
    return [
      BlocProvider<NoticeboardWatcherBloc>(
        create: (BuildContext context) => NoticeboardWatcherBloc(
          noticeboardRepository: _sl(),
        ),
      ),
      BlocProvider<AttachmentDownloadBloc>(
        create: (BuildContext context) => AttachmentDownloadBloc(
          noticeboardRepository: _sl(),
        ),
      ),
    ];
  }
}
