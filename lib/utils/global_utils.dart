import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:registro_elettronico/component/registro_costants.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/utils/entity/datetime_interval.dart';
import 'package:registro_elettronico/utils/subjects_constants.dart';

class GlobalUtils {
  static int getSubjectConstFromName(String subjectName) {
    final stringToCompare = subjectName.toUpperCase();
    switch (stringToCompare) {
      case "MATEMATICA E COMPLEMENTI DI MATEMATICA":
        return SubjectsConstants.MATEMATICA;
        break;
      case "RELIGIONE CATTOLICA / ATTIVITA ALTERNATIVA":
        return SubjectsConstants.RELIGIONE;
        break;
      case "LINGUA INGLESE":
        return SubjectsConstants.INGLESE;
        break;
      case "TECNOLOGIE E PROGETTAZIONE DI SISTEMI INFORMATICI E DI TELECOMUNICAZIONI":
        return SubjectsConstants.TPSIT;
        break;
      case "LINGUA E LETTERATURA ITALIANA":
        return SubjectsConstants.ITALIANO;
        break;
      case "SCIENZE MOTORIE E SPORTIVE":
        return SubjectsConstants.GINNASTICA;
        break;
      default:
        return -1;
    }
  }

  static String translateSubject(int subjectId) {
    switch (subjectId) {
      case SubjectsConstants.MATEMATICA:
        return "MATEMATICA";
        break;
      default:
        return "";
    }
  }

  static List<Subject> removeUnwantedSubject(List<Subject> subjects) {
    subjects.removeWhere((subject) => isUnwanted(subject.name));
    return subjects;
  }

  static bool isUnwanted(String name) {
    if (name == RegistroCostants.SOSTEGNO_FULL) return true;
    return false;
  }

  static String reduceSubjectGridTitle(String subjectName) {
    String reducedName;
    final subjId = getSubjectConstFromName(subjectName);
    reducedName = translateSubject(subjId);
    if (reducedName != "") {
      return reducedName;
    } else {
      reducedName = subjectName.substring(0, 13);
      reducedName += "...";
      return reducedName;
    }
  }

  static String reduceSubjectTitle(String subjectTitle) {
    String reducedName;
    final subjId = getSubjectConstFromName(subjectTitle);
    reducedName = translateSubject(subjId);
    if (reducedName != "") {
      return reducedName;
    } else {
      reducedName = subjectTitle.substring(0, 20);
      reducedName += "...";
      return reducedName;
    }
  }

  static String reduceLessonArgument(String argument) {
    String reducedName = argument.substring(0, 25);
    reducedName += "...";
    return reducedName;
  }

  static Color generateRandomColor() {
    return Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0)
        .withOpacity(1.0);
  }

  static Color getColorFromPosition(int position) {
    switch (position) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.indigo;
        break;
      case 3:
        return Colors.green;
        break;
      case 4:
        return Colors.amber;
        break;
      case 5:
        return Colors.deepOrange;
        break;
      case 6:
        return Colors.indigo;
        break;
      default:
        return Colors.red;
    }
  }

  static SvgPicture getIconFromSubject(String subjectName) {
    final subjectId = getSubjectConstFromName(subjectName);
    return getIconFromSubjectId(subjectId);
  }

  static SvgPicture getIconFromSubjectId(int subjectId) {
    switch (subjectId) {
      case SubjectsConstants.MATEMATICA:
        return SvgPicture.asset(
          "assets/icons/science-symbol.svg",
        );
        break;
      case SubjectsConstants.ITALIANO:
        return SvgPicture.asset(
          "assets/icons/subjects/italiano.svg",
        );
        break;
      case SubjectsConstants.TPSIT:
        return SvgPicture.asset(
          "assets/icons/subjects/informatica2.svg",
        );
        break;
      default:
        return SvgPicture.asset(
          "assets/icons/book_red_lines.svg",
        );
    }
  }

  static String convertDate(DateTime date) {
    final formatter = DateFormat('yyyyMMdd');
    return formatter.format(date);
  }

  static String convertDateForDisplay(DateTime date) {
    final formatter = DateFormat('dd MMMM yy');
    return formatter.format(date);
  }

  /// this returns the max interval to fetch all the lessons / grades
  /// for example if it is november 2019 it fetches => sep 2019 -> aug 2020
  static DateTimeInterval getDateInerval() {
    final now = DateTime.now();
    int yearBegin = now.year;
    int yearEnd = now.year;

    // if we are before sempember we need to fetch from the last year
    if (now.month > DateTime.september) {
      yearEnd += 1;
    } else {
      yearBegin -= 1;
    }

    final DateTime beginDate = DateTime.utc(yearBegin, DateTime.september, 1);
    final DateTime endDate = DateTime.utc(yearEnd, DateTime.august, 31);

    final begin = GlobalUtils.convertDate(beginDate);
    final end = GlobalUtils.convertDate(endDate);

    return DateTimeInterval(begin: begin, end: end);
  }

  static MaterialColor getColorFromGrade(double average) {
    if (average >= 6) {
      return Colors.green;
    } else if (average >= 5.5 && average < 6) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }
}
