import 'package:dio/dio.dart';
import 'package:injector/injector.dart';
import 'package:registro_elettronico/data/db/dao/profile_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/network/service/api/dio_client.dart';
import 'package:registro_elettronico/data/network/service/api/spaggiari_client.dart';
import 'package:registro_elettronico/data/repository/lessons_repository_impl.dart';
import 'package:registro_elettronico/data/repository/login_repository_impl.dart';
import 'package:registro_elettronico/data/repository/mapper/profile_mapper.dart';
import 'package:registro_elettronico/data/repository/profile_repository_impl.dart';
import 'package:registro_elettronico/domain/repository/lessons_repository.dart';
import 'package:registro_elettronico/domain/repository/login_repository.dart';
import 'package:registro_elettronico/domain/repository/profile_repository.dart';
import 'package:registro_elettronico/ui/bloc/auth/auth_bloc.dart';

class AppInjector {
  static void init() {
    injectDatabase();
    injectService();
    injectRepository();
    injectBloc();
    injectMapper();
  }

  static void injectMapper() {
    // mappers to convert the response to db object
    Injector.appInstance.registerSingleton((injector) {
      return ProfileMapper();
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
      LessonsRepository lessonsRepository =
          LessonsRepositoryImpl(i.getDependency());
      return lessonsRepository;
    });
  }

  static void injectService() {
    Injector.appInstance.registerSingleton<Dio>((i) {
      return DioClient(i.getDependency()).createDio();
    });

    Injector.appInstance.registerSingleton<SpaggiariClient>((i) {
      return SpaggiariClient(i.getDependency());
    });
    //Injector.appInstance.registerSingleton((injector) {
    //  return SpaggiariClient(DioClient().createDio());
    //});
  }

  static void injectBloc() {
    Injector.appInstance.registerSingleton((i) {
      return AuthBloc(i.getDependency(), i.getDependency());
    });
  }
}
