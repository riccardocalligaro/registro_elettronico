import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/data/remote/api/spaggiari_client.dart';
import 'package:registro_elettronico/core/data/remote/api/sr_dio_client.dart';
import 'package:registro_elettronico/core/data/remote/web/web_spaggiari_client.dart';
import 'package:registro_elettronico/core/data/remote/web/web_spaggiari_client_impl.dart';
import 'package:registro_elettronico/core/infrastructure/network/network_info.dart';
import 'package:registro_elettronico/core/infrastructure/notification/fcm_service.dart';
import 'package:registro_elettronico/feature/absences/absences_container.dart';
import 'package:registro_elettronico/feature/agenda/agenda_container.dart';
import 'package:registro_elettronico/feature/authentication/authentication_container.dart';
import 'package:registro_elettronico/feature/lessons/lessons_container.dart';
import 'package:registro_elettronico/feature/noticeboard/noticeboard_container.dart';
import 'package:registro_elettronico/feature/periods/periods_container.dart';
import 'package:registro_elettronico/feature/professors/professors_container.dart';
import 'package:registro_elettronico/feature/scrutini/data/dao/document_dao.dart';
import 'package:registro_elettronico/feature/scrutini/data/repository/documents_repository_impl.dart';
import 'package:registro_elettronico/feature/scrutini/data/repository/scrutini_repository_impl.dart';
import 'package:registro_elettronico/feature/scrutini/domain/repository/documents_repository.dart';
import 'package:registro_elettronico/feature/scrutini/domain/repository/scrutini_repository.dart';
import 'package:registro_elettronico/feature/stats/data/repository/stats_repository_impl.dart';
import 'package:registro_elettronico/feature/stats/domain/repository/stats_repository.dart';
import 'package:registro_elettronico/feature/subjects/subjects_container.dart';
import 'package:registro_elettronico/feature/timetable/timetable_container.dart';
import 'package:registro_elettronico/utils/update_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'didactics/didactics_container.dart';
import 'grades/grades_container.dart';
import 'notes/data/dao/note_dao.dart';
import 'notes/data/repository/notes_repository_impl.dart';
import 'notes/domain/repository/notes_repository.dart';

final _sl = GetIt.instance;

class CoreContainer {
  static Future<void> init() async {
    //! Services

    final sharedPreferences = await SharedPreferences.getInstance();
    _sl.registerLazySingleton(() => sharedPreferences);

    _sl.registerLazySingleton(() => DataConnectionChecker());
    _sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(_sl()));
    _sl.registerLazySingleton(() => FlutterSecureStorage());

    _sl.registerLazySingleton<SRDatabase>(() => SRDatabase());

    await AuthenticationContainer.init();

    _sl.registerLazySingleton<Dio>(
      () => SRDioClient(
        flutterSecureStorage: _sl(),
        sharedPreferences: _sl(),
        authenticationRepository: _sl(),
      ).createDio(),
    );

    _sl.registerLazySingleton(() => Dio(), instanceName: 'WebSpaggiariDio');

    _sl.registerLazySingleton(() => LegacySpaggiariClient(_sl()));
    _sl.registerLazySingleton<WebSpaggiariClient>(() =>
        WebSpaggiariClientImpl(_sl.get<Dio>(instanceName: 'WebSpaggiariDio')));

    _sl.registerLazySingleton(() => PushNotificationService(_sl()));

    await ProfessorsContainer.init();
    await PeriodsContainer.init();
    await SubjectsContainer.init();
    await LessonsContainer.init();
    await AgendaContainer.init();
    await NoticeboardContainer.init();
    await TimetableContainer.init();
    await GradesContainer.init();
    await AbsencesContainer.init();
    await DidacticsContainer.init();

    sl.registerLazySingleton(() => NoteDao(sl()));
    sl.registerLazySingleton(() => DocumentsDao(sl()));

    sl.registerLazySingleton<NotesRepository>(
        () => NotesRepositoryImpl(sl(), sl(), sl(), sl(), sl()));

    sl.registerLazySingleton<DocumentsRepository>(
      () => DocumentsRepositoryImpl(
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
      ),
    );

    sl.registerLazySingleton<ScrutiniRepository>(
      () => ScrutiniRepositoryImpl(
        sl(),
        sl(),
        sl(),
        sl(),
      ),
    );

    sl.registerLazySingleton<StatsRepository>(
      () => StatsRepositoryImpl(
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
      ),
    );

    _sl.registerLazySingleton(() {
      return SRUpdateManager(
        sharedPreferences: _sl(),
        absencesRepository: _sl(),
        agendaRepository: _sl(),
        didacticsRepository: _sl(),
        gradesRepository: _sl(),
        lessonsRepository: _sl(),
        noticesRepository: _sl(),
        periodsRepository: _sl(),
        subjectsRepository: _sl(),
        documentsRepository: _sl(),
        notesRepository: _sl(),
        timetableRepository: _sl(),
      );
    });
  }

  static List<BlocProvider> getBlocProviders() {
    return [
      ...LessonsContainer.getBlocProviders(),
      ...SubjectsContainer.getBlocProviders(),
      ...NoticeboardContainer.getBlocProviders(),
      ...TimetableContainer.getBlocProviders(),
      ...AuthenticationContainer.getBlocProviders(),
      ...GradesContainer.getBlocProviders(),
      ...AgendaContainer.getBlocProviders(),
      ...DidacticsContainer.getBlocProviders(),
    ];
  }
}
