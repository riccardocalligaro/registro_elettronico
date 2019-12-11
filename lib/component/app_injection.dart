import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injector/injector.dart';
import 'package:registro_elettronico/data/db/dao/grade_dao.dart';
import 'package:registro_elettronico/data/db/dao/lesson_dao.dart';
import 'package:registro_elettronico/data/db/dao/professor_dao.dart';
import 'package:registro_elettronico/data/db/dao/profile_dao.dart';
import 'package:registro_elettronico/data/db/dao/subject_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/network/service/api/dio_client.dart';
import 'package:registro_elettronico/data/network/service/api/spaggiari_client.dart';
import 'package:registro_elettronico/data/repository/grades_repository_impl.dart';
import 'package:registro_elettronico/data/repository/lessons_repository_impl.dart';
import 'package:registro_elettronico/data/repository/login_repository_impl.dart';
import 'package:registro_elettronico/data/repository/mapper/grade_mapper.dart';
import 'package:registro_elettronico/data/repository/mapper/lesson_mapper.dart';
import 'package:registro_elettronico/data/repository/mapper/profile_mapper.dart';
import 'package:registro_elettronico/data/repository/mapper/subject_mapper.dart';
import 'package:registro_elettronico/data/repository/profile_repository_impl.dart';
import 'package:registro_elettronico/data/repository/subjects_resposiotry_impl.dart';
import 'package:registro_elettronico/domain/repository/grades_repository.dart';
import 'package:registro_elettronico/domain/repository/lessons_repository.dart';
import 'package:registro_elettronico/domain/repository/login_repository.dart';
import 'package:registro_elettronico/domain/repository/profile_repository.dart';
import 'package:registro_elettronico/domain/repository/subjects_repository.dart';
import 'package:registro_elettronico/ui/bloc/auth/auth_bloc.dart';

class AppInjector {
  static void init() {
    injectDatabase();
    injectService();
    injectRepository();
    injectBloc();
    injectMapper();
    injectMisc();
  }

  static void injectMisc() {
    Injector.appInstance.registerSingleton<FlutterSecureStorage>((i) {
      return FlutterSecureStorage();
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
  }

  static void injectDatabase() {
    // main database
    Injector.appInstance.registerSingleton<AppDatabase>((injector) {
      return AppDatabase();
    });
    // daos
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
          i.getDependency(), i.getDependency(), i.getDependency());
      return lessonsRepository;
    });

    Injector.appInstance.registerSingleton((i) {
      SubjectsRepository lessonsRepository = SubjectsRepositoryImpl(
          i.getDependency(),
          i.getDependency(),
          i.getDependency(),
          i.getDependency());
      return lessonsRepository;
    });

    Injector.appInstance.registerSingleton((i) {
      GradesRepository lessonsRepository = GradesRepositoryImpl(
          i.getDependency(), i.getDependency(), i.getDependency());
      return lessonsRepository;
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

  static void injectBloc() {
    Injector.appInstance.registerSingleton((i) {
      return AuthBloc(i.getDependency(), i.getDependency(), i.getDependency());
    });
  }
}
