import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/data/remote/api/dio_client.dart';
import 'package:registro_elettronico/core/data/remote/api/spaggiari_client.dart';
import 'package:registro_elettronico/core/data/remote/web/web_spaggiari_client.dart';
import 'package:registro_elettronico/core/data/remote/web/web_spaggiari_client_impl.dart';
import 'package:registro_elettronico/core/infrastructure/notification/fcm_service.dart';
import 'package:registro_elettronico/feature/absences/data/dao/absence_dao.dart';
import 'package:registro_elettronico/feature/absences/data/repository/absences_repository_impl.dart';
import 'package:registro_elettronico/feature/absences/domain/repository/absences_repository.dart';
import 'package:registro_elettronico/feature/agenda/agenda_container.dart';
import 'package:registro_elettronico/feature/core_container.dart';
import 'package:registro_elettronico/feature/didactics/data/dao/didactics_dao.dart';
import 'package:registro_elettronico/feature/didactics/data/repository/didactics_repository_impl.dart';
import 'package:registro_elettronico/feature/didactics/domain/repository/didactics_repository.dart';
import 'package:registro_elettronico/feature/grades/grades_container.dart';
import 'package:registro_elettronico/feature/login/data/repository/login_repository_impl.dart';
import 'package:registro_elettronico/feature/login/domain/repository/login_repository.dart';
import 'package:registro_elettronico/feature/login/presentation/bloc/auth_bloc.dart';
import 'package:registro_elettronico/feature/notes/data/dao/note_dao.dart';
import 'package:registro_elettronico/feature/notes/data/repository/notes_repository_impl.dart';
import 'package:registro_elettronico/feature/notes/domain/repository/notes_repository.dart';
import 'package:registro_elettronico/feature/profile/data/dao/profiles_local_datasource.dart';
import 'package:registro_elettronico/feature/profile/data/repository/profile_repository_impl.dart';
import 'package:registro_elettronico/feature/profile/domain/repository/authentication_repository.dart';
import 'package:registro_elettronico/feature/scrutini/data/dao/document_dao.dart';
import 'package:registro_elettronico/feature/scrutini/data/repository/documents_repository_impl.dart';
import 'package:registro_elettronico/feature/scrutini/data/repository/scrutini_repository_impl.dart';
import 'package:registro_elettronico/feature/scrutini/domain/repository/documents_repository.dart';
import 'package:registro_elettronico/feature/scrutini/domain/repository/scrutini_repository.dart';
import 'package:registro_elettronico/feature/stats/data/repository/stats_repository_impl.dart';
import 'package:registro_elettronico/feature/stats/domain/repository/stats_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'network/network_info.dart';

final sl = GetIt.instance;

class AppInjector {
  static Future<void> init() async {
    await CoreContainer.init();
    // Inject the application database
    injectDatabase();
    // Inject all the daos
    injectDaos();
    // Inject mis services
    injectMisc();
    // Inject Dio and the api spagggiari client
    injectService();
    // Inject all the repositories
    injectRepository();
    // Inject all the mappers to convert db objects -> entity and vice versa
    injectBloc();

    injectSharedPreferences();

    await GradesContainer.init();
    await AgendaContainer.init();
  }

  static void injectDatabase() {
    sl.registerLazySingleton<AppDatabase>(() => AppDatabase());
  }

  // All the DAOS (Data Access Objects)
  static void injectDaos() {
    sl.registerLazySingleton(() => AbsenceDao(sl()));
    sl.registerLazySingleton(() => NoteDao(sl()));
    sl.registerLazySingleton(() => DidacticsDao(sl()));
    sl.registerLazySingleton(() => DocumentsDao(sl()));
  }

  static void injectMisc() {
    sl.registerLazySingleton(() => DataConnectionChecker());
    sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
    sl.registerLazySingleton(() => FlutterSecureStorage());
  }

  static void injectService() {
    sl.registerLazySingleton<Dio>(
      () => DioClient(sl(), sl(), sl()).createDio(),
    );
    sl.registerLazySingleton(() => Dio(), instanceName: 'WebSpaggiariDio');

    sl.registerLazySingleton(() => SpaggiariClient(sl()));
    sl.registerLazySingleton<WebSpaggiariClient>(() =>
        WebSpaggiariClientImpl(sl.get<Dio>(instanceName: 'WebSpaggiariDio')));

    sl.registerLazySingleton<FirebaseMessaging>(
      () => FirebaseMessaging(),
    );

    sl.registerLazySingleton(() => PushNotificationService(sl()));
  }

  static void injectRepository() {
    sl.registerLazySingleton<LoginRepository>(
        () => LoginRepositoryImpl(sl(), sl(), sl()));

    sl.registerLazySingleton<AbsencesRepository>(
        () => AbsencesRepositoryImpl(sl(), sl(), sl(), sl(), sl(), sl()));

    sl.registerLazySingleton<NotesRepository>(
        () => NotesRepositoryImpl(sl(), sl(), sl(), sl(), sl()));

    sl.registerLazySingleton<DidacticsRepository>(
        () => DidacticsRepositoryImpl(sl(), sl(), sl(), sl(), sl(), sl()));

    sl.registerLazySingleton<DocumentsRepository>(
        () => DocumentsRepositoryImpl(sl(), sl(), sl(), sl(), sl()));

    sl.registerLazySingleton<ScrutiniRepository>(
        () => ScrutiniRepositoryImpl(sl(), sl(), sl(), sl()));

    sl.registerLazySingleton<StatsRepository>(
        () => StatsRepositoryImpl(sl(), sl(), sl(), sl(), sl(), sl(), sl()));
  }

  static void injectBloc() {
    sl.registerLazySingleton<AuthBloc>(
      () => AuthBloc(
        profileRepository: sl(),
        loginRepository: sl(),
        flutterSecureStorage: sl(),
        sharedPreferences: sl(),
      ),
    );
  }

  static void injectSharedPreferences() async {
    WidgetsFlutterBinding.ensureInitialized();
    final sharedPreferences = await SharedPreferences.getInstance();
    sl.registerLazySingleton(() => sharedPreferences);
  }
}
