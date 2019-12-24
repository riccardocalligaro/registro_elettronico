import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:registro_elettronico/component/notifications/local_notification.dart';
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
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/constants/preferences_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  //GradesRepository gradesRepository;

  //NotificationService(this.gradesRepository);

  Future checkForNewContent() async {
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

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final LocalNotification localNotification =
        LocalNotification(onSelectNotification);
    print("Before if!");

    //if (prefs.getBool('notify_grades') == false) {
    final difference = await getGradesDifference(gradesRepository);

    print("Difference " + difference.toString());

    //final locale = Locale(Platform.localeName);
    //final localizations = await AppLocalizations.delegate.load(locale);
    //SharedPreferences preferences = await SharedPreferences.getInstance();
    //print(preferences.getBool(PrefsConstants.GRADES_NOTIFICATIONS) ?? "false");

    difference.forEach(
      (grade) => localNotification.showNotificationWithDefaultSound(
        grade.evtId,
        'Nuovi voti!',
        'Hai preso ${grade.decimalValue.toString()} in ${grade.subjectDesc}',
      ),
    );
  }

  Future<List<Grade>> getGradesDifference(
      GradesRepository gradesRepository) async {
    List<Grade> gradesToNotify = [];
    final gradesBeforeFetching = await gradesRepository.getAllGrades();
    //final res = await gradesRepository.updateGrades();
    final gradesAfterFetching = await gradesRepository.getAllGrades();

    gradesAfterFetching.forEach(
      (grade) => {
        if (!gradesBeforeFetching.contains(grade)) gradesToNotify.add(grade)
      },
    );

    return gradesToNotify;
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      print('notification payload: ' + payload);
    }
  }
}
