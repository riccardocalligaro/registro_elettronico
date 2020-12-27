import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:registro_elettronico/core/network/network_info.dart';
import 'package:registro_elettronico/feature/absences/data/dao/absence_dao.dart';
import 'package:registro_elettronico/feature/agenda/data/dao/agenda_dao.dart';
import 'package:registro_elettronico/data/db/dao/didactics_dao.dart';
import 'package:registro_elettronico/data/db/dao/document_dao.dart';
import 'package:registro_elettronico/feature/grades/data/dao/grade_dao.dart';
import 'package:registro_elettronico/feature/lessons/data/dao/lesson_dao.dart';
import 'package:registro_elettronico/feature/notes/data/dao/note_dao.dart';
import 'package:registro_elettronico/feature/noticeboard/data/dao/notice_dao.dart';
import 'package:registro_elettronico/data/db/dao/period_dao.dart';
import 'package:registro_elettronico/data/db/dao/professor_dao.dart';
import 'package:registro_elettronico/data/db/dao/profile_dao.dart';
import 'package:registro_elettronico/data/db/dao/subject_dao.dart';
import 'package:registro_elettronico/feature/timetable/data/dao/timetable_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/network/service/api/dio_client.dart';
import 'package:registro_elettronico/data/network/service/api/spaggiari_client.dart';
import 'package:registro_elettronico/data/network/service/web/web_spaggiari_client.dart';
import 'package:registro_elettronico/data/network/service/web/web_spaggiari_client_impl.dart';
import 'package:registro_elettronico/feature/absences/data/repository/absences_repository_impl.dart';
import 'package:registro_elettronico/feature/didactics/data/repository/didactics_repository_impl.dart';
import 'package:registro_elettronico/data/repository/documents_repository_impl.dart';
import 'package:registro_elettronico/feature/notes/data/repository/notes_repository_impl.dart';
import 'package:registro_elettronico/feature/noticeboard/data/repository/notices_repository_impl.dart';
import 'package:registro_elettronico/data/repository/periods_repository_impl.dart';
import 'package:registro_elettronico/data/repository/repository_impl_export.dart';
import 'package:registro_elettronico/data/repository/scrutini_repository_impl.dart';
import 'package:registro_elettronico/feature/stats/data/repository/stats_repository_impl.dart';
import 'package:registro_elettronico/feature/timetable/data/repository/timetable_repository_impl.dart';
import 'package:registro_elettronico/feature/absences/domain/repository/absences_repository.dart';
import 'package:registro_elettronico/feature/didactics/domain/repository/didactics_repository.dart';
import 'package:registro_elettronico/domain/repository/documents_repository.dart';
import 'package:registro_elettronico/feature/notes/domain/repository/notes_repository.dart';
import 'package:registro_elettronico/feature/noticeboard/domain/repository/notices_repository.dart';
import 'package:registro_elettronico/domain/repository/periods_repository.dart';
import 'package:registro_elettronico/domain/repository/repositories_export.dart';
import 'package:registro_elettronico/domain/repository/scrutini_repository.dart';
import 'package:registro_elettronico/feature/stats/domain/repository/stats_repository.dart';
import 'package:registro_elettronico/feature/timetable/domain/repository/timetable_repository.dart';
import 'package:registro_elettronico/ui/bloc/auth/auth_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

class AppInjector {
  static void init() {
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
  }

  static void injectDatabase() {
    sl.registerLazySingleton(() => AppDatabase());
  }

  // All the DAOS (Data Access Objects)
  static void injectDaos() {
    sl.registerLazySingleton(() => ProfileDao(sl()));
    sl.registerLazySingleton(() => LessonDao(sl()));
    sl.registerLazySingleton(() => ProfessorDao(sl()));
    sl.registerLazySingleton(() => SubjectDao(sl()));
    sl.registerLazySingleton(() => GradeDao(sl()));
    sl.registerLazySingleton(() => AgendaDao(sl()));
    sl.registerLazySingleton(() => AbsenceDao(sl()));
    sl.registerLazySingleton(() => PeriodDao(sl()));
    sl.registerLazySingleton(() => NoticeDao(sl()));
    sl.registerLazySingleton(() => NoteDao(sl()));
    sl.registerLazySingleton(() => DidacticsDao(sl()));
    sl.registerLazySingleton(() => TimetableDao(sl()));
    sl.registerLazySingleton(() => DocumentsDao(sl()));
  }

  static void injectMisc() {
    sl.registerLazySingleton(() => DataConnectionChecker());
    sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
    sl.registerLazySingleton(() => FlutterSecureStorage());
  }

  static void injectService() {
    sl.registerLazySingleton<Dio>(
      () => DioClient(sl(), sl()).createDio(),
    );
    sl.registerLazySingleton(() => Dio(), instanceName: 'WebSpaggiariDio');

    sl.registerLazySingleton(() => SpaggiariClient(sl()));
    sl.registerLazySingleton<WebSpaggiariClient>(() =>
        WebSpaggiariClientImpl(sl.get<Dio>(instanceName: 'WebSpaggiariDio')));
  }

  static void injectRepository() {
    sl.registerLazySingleton<LoginRepository>(
        () => LoginRepositoryImpl(sl(), sl(), sl()));

    sl.registerLazySingleton<ProfileRepository>(
        () => ProfileRepositoryImpl(sl(), sl()));

    sl.registerLazySingleton<LessonsRepository>(
        () => LessonsRepositoryImpl(sl(), sl(), sl(), sl()));

    sl.registerLazySingleton<SubjectsRepository>(
        () => SubjectsRepositoryImpl(sl(), sl(), sl(), sl(), sl()));

    sl.registerLazySingleton<GradesRepository>(
        () => GradesRepositoryImpl(sl(), sl(), sl(), sl()));

    sl.registerLazySingleton<AgendaRepository>(
        () => AgendaRepositoryImpl(sl(), sl(), sl(), sl()));

    sl.registerLazySingleton<AbsencesRepository>(
        () => AbsencesRepositoryImpl(sl(), sl(), sl(), sl()));

    sl.registerLazySingleton<PeriodsRepository>(
        () => PeriodsRepositoryImpl(sl(), sl(), sl(), sl()));

    sl.registerLazySingleton<NoticesRepository>(
        () => NoticesRepositoryImpl(sl(), sl(), sl(), sl()));

    sl.registerLazySingleton<NotesRepository>(
        () => NotesRepositoryImpl(sl(), sl(), sl(), sl()));

    sl.registerLazySingleton<DidacticsRepository>(
        () => DidacticsRepositoryImpl(sl(), sl(), sl(), sl()));

    sl.registerLazySingleton<TimetableRepository>(
        () => TimetableRepositoryImpl(sl(), sl()));

    sl.registerLazySingleton<DocumentsRepository>(
        () => DocumentsRepositoryImpl(sl(), sl(), sl(), sl()));

    sl.registerLazySingleton<ScrutiniRepository>(
        () => ScrutiniRepositoryImpl(sl(), sl(), sl(), sl()));

    sl.registerLazySingleton<StatsRepository>(
        () => StatsRepositoryImpl(sl(), sl(), sl(), sl(), sl(), sl()));
  }

  static void injectBloc() {
    sl.registerLazySingleton<AuthBloc>(() => AuthBloc(sl(), sl(), sl()));
  }

  static void injectSharedPreferences() async {
    WidgetsFlutterBinding.ensureInitialized();
    final sharedPreferences = await SharedPreferences.getInstance();
    sl.registerLazySingleton(() => sharedPreferences);
  }
}
