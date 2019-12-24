import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injector/injector.dart';
import 'package:registro_elettronico/data/db/dao/grade_dao.dart';
import 'package:registro_elettronico/data/db/dao/profile_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/network/service/api/dio_client.dart';
import 'package:registro_elettronico/data/network/service/api/spaggiari_client.dart';
import 'package:registro_elettronico/data/repository/grades_repository_impl.dart';
import 'package:registro_elettronico/data/repository/mapper/grade_mapper.dart';
import 'package:registro_elettronico/data/repository/mapper/profile_mapper.dart';
import 'package:registro_elettronico/data/repository/profile_repository_impl.dart';
import 'package:registro_elettronico/domain/repository/grades_repository.dart';
import 'package:registro_elettronico/domain/repository/profile_repository.dart';

class NotificationService {
  //GradesRepository gradesRepository;

  //NotificationService(this.gradesRepository);

  Future checkForNewContent() async {
    // We need to create a lot of objects!
    final GradeDao gradeDao = GradeDao(AppDatabase());
    final ProfileDao profileDao = ProfileDao(AppDatabase());
    final ProfileMapper profileMapper = ProfileMapper();
    final ProfileRepository profileRepository =
        ProfileRepositoryImpl(profileDao, profileMapper);
    final FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();
    final DioClient dioClient =
        DioClient(ProfileMapper(), profileRepository, flutterSecureStorage);
    final SpaggiariClient spaggiariClient =
        SpaggiariClient(dioClient.createDio());
    final GradeMapper gradeMapper = GradeMapper();
    final GradesRepository gradesRepository = GradesRepositoryImpl(
        gradeDao, spaggiariClient, gradeMapper, profileDao);

    // final gradesBeforeFetching = await gradeDao.getAllGrades();
    // await gradesRepository.updateGrades();
    // final gradesAfterFetching = await gradeDao.getAllGrades();

    /// Checks the lenght of the lists, in case there is a difference
    /// it should notify the user
    // if (gradesBeforeFetching.length != gradesAfterFetching.length) {
    //   print("New grades!");
    // } else {
    //   print("No new grades");
    // }
  }
}
