import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injector/injector.dart';
import 'package:registro_elettronico/data/db/dao/absence_dao.dart';
import 'package:registro_elettronico/data/db/dao/agenda_dao.dart';
import 'package:registro_elettronico/data/db/dao/didactics_dao.dart';
import 'package:registro_elettronico/data/db/dao/grade_dao.dart';
import 'package:registro_elettronico/data/db/dao/lesson_dao.dart';
import 'package:registro_elettronico/data/db/dao/note_dao.dart';
import 'package:registro_elettronico/data/db/dao/notice_dao.dart';
import 'package:registro_elettronico/data/db/dao/period_dao.dart';
import 'package:registro_elettronico/data/db/dao/professor_dao.dart';
import 'package:registro_elettronico/data/db/dao/profile_dao.dart';
import 'package:registro_elettronico/data/db/dao/subject_dao.dart';
import 'package:registro_elettronico/data/db/dao/timetable_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/network/service/api/dio_client.dart';
import 'package:registro_elettronico/data/network/service/api/spaggiari_client.dart';
import 'package:registro_elettronico/data/repository/absences_repository_impl.dart';
import 'package:registro_elettronico/data/repository/didactics_repository_impl.dart';
import 'package:registro_elettronico/data/repository/mapper/absence_mapper.dart';

// All the mappers to convert an entity to a db entity and vice versa
import 'package:registro_elettronico/data/repository/mapper/mappers_export.dart';
import 'package:registro_elettronico/data/repository/mapper/note_mapper.dart';
import 'package:registro_elettronico/data/repository/mapper/notice_mapper.dart';
import 'package:registro_elettronico/data/repository/mapper/period_mapper.dart';
import 'package:registro_elettronico/data/repository/notes_repository_impl.dart';
import 'package:registro_elettronico/data/repository/notices_repository_impl.dart';
import 'package:registro_elettronico/data/repository/periods_repository_impl.dart';

// All the data level repositories
import 'package:registro_elettronico/data/repository/repository_impl_export.dart';
import 'package:registro_elettronico/data/repository/timetable_repository_impl.dart';
import 'package:registro_elettronico/domain/repository/absences_repository.dart';
import 'package:registro_elettronico/domain/repository/didactics_repository.dart';
import 'package:registro_elettronico/domain/repository/notes_repository.dart';
import 'package:registro_elettronico/domain/repository/notices_repository.dart';
import 'package:registro_elettronico/domain/repository/periods_repository.dart';

// All the domain level repositories
import 'package:registro_elettronico/domain/repository/repositories_export.dart';
import 'package:registro_elettronico/domain/repository/timetable_repository.dart';

// BLoc
import 'package:registro_elettronico/ui/bloc/auth/auth_bloc.dart';

// Compile-time dependency injection for Dart and Flutter, similar to Dagger.

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
    injectMapper();
    // Only authbloc for now
    injectBloc();
    // Inject shared preferences
    injectSharedPreferences();
  }

  static void injectDatabase() {
    // This is the singleton for the main database of the application
    Injector.appInstance.registerSingleton<AppDatabase>((injector) {
      return AppDatabase();
    });
  }

  // All the DAOS (Data Access Objects)
  static void injectDaos() {
    Injector.appInstance.registerSingleton<ProfileDao>((injector) {
      return ProfileDao(injector.getDependency());
    });

    Injector.appInstance.registerSingleton<LessonDao>((i) {
      return LessonDao(i.getDependency());
    });

    Injector.appInstance.registerSingleton<ProfessorDao>((i) {
      return ProfessorDao(i.getDependency());
    });

    Injector.appInstance.registerSingleton<SubjectDao>((i) {
      return SubjectDao(i.getDependency());
    });

    Injector.appInstance.registerSingleton<GradeDao>((i) {
      return GradeDao(i.getDependency());
    });

    Injector.appInstance.registerSingleton<AgendaDao>((i) {
      return AgendaDao(i.getDependency());
    });

    Injector.appInstance.registerSingleton<AbsenceDao>((i) {
      return AbsenceDao(i.getDependency());
    });

    Injector.appInstance.registerSingleton<PeriodDao>((i) {
      return PeriodDao(i.getDependency());
    });

    Injector.appInstance.registerSingleton<NoticeDao>((i) {
      return NoticeDao(i.getDependency());
    });

    Injector.appInstance.registerSingleton<NoteDao>((i) {
      return NoteDao(i.getDependency());
    });

    Injector.appInstance.registerSingleton<DidacticsDao>((i) {
      return DidacticsDao(i.getDependency());
    });

    Injector.appInstance.registerSingleton<TimetableDao>((i) {
      return TimetableDao(i.getDependency());
    });
  }

  static void injectMisc() {
    // This is for storing the user credentials
    Injector.appInstance.registerSingleton<FlutterSecureStorage>((i) {
      return FlutterSecureStorage();
    });
  }

  static void injectService() {
    Injector.appInstance.registerSingleton<Dio>((i) {
      return DioClient(i.getDependency(), i.getDependency(), i.getDependency())
          .createDio();
    });

    Injector.appInstance.registerSingleton<SpaggiariClient>((i) {
      return SpaggiariClient(i.getDependency());
    });
  }

  static void injectRepository() {
    Injector.appInstance.registerSingleton((i) {
      LoginRepository loginRepository = LoginRepositoryImpl(
          i.getDependency(), i.getDependency(), i.getDependency());
      return loginRepository;
    });

    Injector.appInstance.registerSingleton((i) {
      ProfileRepository profileRepository =
          ProfileRepositoryImpl(i.getDependency(), i.getDependency());
      return profileRepository;
    });

    Injector.appInstance.registerSingleton((i) {
      LessonsRepository lessonsRepository = LessonsRepositoryImpl(
        i.getDependency(),
        i.getDependency(),
        i.getDependency(),
        i.getDependency(),
      );
      return lessonsRepository;
    });

    Injector.appInstance.registerSingleton((i) {
      SubjectsRepository subjectsRepository = SubjectsRepositoryImpl(
        i.getDependency(),
        i.getDependency(),
        i.getDependency(),
        i.getDependency(),
        i.getDependency(),
      );
      return subjectsRepository;
    });

    Injector.appInstance.registerSingleton((i) {
      GradesRepository gradesRepository = GradesRepositoryImpl(
        i.getDependency(),
        i.getDependency(),
        i.getDependency(),
        i.getDependency(),
      );
      return gradesRepository;
    });

    Injector.appInstance.registerSingleton((i) {
      AgendaRepository agendaRepository = AgendaRepositoryImpl(
        i.getDependency(),
        i.getDependency(),
        i.getDependency(),
        i.getDependency(),
      );
      return agendaRepository;
    });

    Injector.appInstance.registerSingleton((i) {
      AbsencesRepository absencesRepository = AbsencesRepositoryImpl(
        i.getDependency(),
        i.getDependency(),
        i.getDependency(),
        i.getDependency(),
      );
      return absencesRepository;
    });

    Injector.appInstance.registerSingleton((i) {
      PeriodsRepository periodsRepository = PeriodsRepositoryImpl(
        i.getDependency(),
        i.getDependency(),
        i.getDependency(),
        i.getDependency(),
      );
      return periodsRepository;
    });

    Injector.appInstance.registerSingleton((i) {
      NoticesRepository noticesRepository = NoticesRepositoryImpl(
        i.getDependency(),
        i.getDependency(),
        i.getDependency(),
        i.getDependency(),
      );
      return noticesRepository;
    });

    Injector.appInstance.registerSingleton((i) {
      NotesRepository notesRepository = NotesRepositoryImpl(
        i.getDependency(),
        i.getDependency(),
        i.getDependency(),
        i.getDependency(),
      );
      return notesRepository;
    });

    Injector.appInstance.registerSingleton((i) {
      DidacticsRepository didacticsRepository = DidacticsRepositoryImpl(
        i.getDependency(),
        i.getDependency(),
        i.getDependency(),
      );
      return didacticsRepository;
    });

    Injector.appInstance.registerSingleton((i) {
      TimetableRepository timetableRepository = TimetableRepositoryImpl(
        i.getDependency(),
        i.getDependency(),
      );
      return timetableRepository;
    });
  }

  static void injectMapper() {
    // mappers to convert the response to db object
    Injector.appInstance.registerSingleton<ProfileMapper>((injector) {
      return ProfileMapper();
    });
    Injector.appInstance.registerSingleton<LessonMapper>((injector) {
      return LessonMapper();
    });

    Injector.appInstance.registerSingleton<SubjectMapper>((injector) {
      return SubjectMapper();
    });

    Injector.appInstance.registerSingleton<GradeMapper>((injector) {
      return GradeMapper();
    });

    Injector.appInstance.registerSingleton<EventMapper>((injector) {
      return EventMapper();
    });

    Injector.appInstance.registerSingleton<AbsenceMapper>((injector) {
      return AbsenceMapper();
    });

    Injector.appInstance.registerSingleton<PeriodMapper>((injector) {
      return PeriodMapper();
    });

    Injector.appInstance.registerSingleton<NoticeMapper>((injector) {
      return NoticeMapper();
    });

    Injector.appInstance.registerSingleton<NoteMapper>((injector) {
      return NoteMapper();
    });
  }

  static void injectBloc() {
    Injector.appInstance.registerSingleton((i) {
      return AuthBloc(i.getDependency(), i.getDependency(), i.getDependency());
    });
  }

  static void injectSharedPreferences() async {}
}
