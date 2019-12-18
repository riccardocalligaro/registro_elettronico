import 'dart:core';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/utils/constants/subjects_constants.dart';

import 'constants/registro_constants.dart';

class GlobalUtils {
  static double getAverage(int subjectId, List<Grade> grades) {
    double sum = 0;
    int count = 0;

    grades.forEach((grade) {
      if (grade.subjectId == subjectId && grade.decimalValue != -1.00) {
        sum += grade.decimalValue;

        count++;
      }
    });
    return sum / count;
  }

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
      case "INFORMATICA":
        return SubjectsConstants.INFORMATICA;
        break;
      case "TELECOMUNICAZIONI":
        return SubjectsConstants.TELECOMUNICAZIONI;
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
      case SubjectsConstants.GINNASTICA:
        return "GINNASTICA";
        break;
      case SubjectsConstants.TPSIT:
        return "TPSIT";
      case SubjectsConstants.ITALIANO:
        return "ITALIANO";
      case SubjectsConstants.RELIGIONE:
        return "RELIGIONE";
      default:
        return "";
    }
  }

  static List<Subject> removeUnwantedSubject(List<Subject> subjects) {
    subjects.removeWhere((subject) => isUnwanted(subject.name));
    return subjects;
  }

  static bool isUnwanted(String name) {
    if (name == RegistroConstants.SOSTEGNO_FULL) return true;
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
      case 0:
        return Colors.deepPurpleAccent;
        break;
      case 1:
        return Colors.redAccent;
        break;
      case 2:
        return Colors.deepOrangeAccent;
        break;
      case 3:
        return Colors.greenAccent;
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
      case SubjectsConstants.ARTE:
        return SvgPicture.asset(
          "assets/icons/subjects/arte.svg",
        );
        break;
      case SubjectsConstants.BIOLOGIA:
        return SvgPicture.asset(
          "assets/icons/subjects/biologia.svg",
        );
        break;
      case SubjectsConstants.CHIMICA:
        return SvgPicture.asset(
          "assets/icons/subjects/chimica3.svg",
        );
        break;
      case SubjectsConstants.TELECOMUNICAZIONI:
        return SvgPicture.asset(
          "assets/icons/subjects/telecomunicazioni.svg",
        );
        break;
      case SubjectsConstants.GEOGRAFIA:
        return SvgPicture.asset(
          "assets/icons/subjects/geografia4.svg",
        );
        break;
      case SubjectsConstants.ELETTRONICA:
        return SvgPicture.asset(
          "assets/icons/subjects/elettronica.svg",
        );
        break;
      case SubjectsConstants.INFORMATICA:
        return SvgPicture.asset(
          "assets/icons/subjects/informatica.svg",
        );
        break;
      case SubjectsConstants.INGLESE:
        return SvgPicture.asset(
          "assets/icons/subjects/inglese.svg",
        );
        break;
      case SubjectsConstants.FRANCESE:
        return SvgPicture.asset(
          "assets/icons/subjects/lingue.svg",
        );
        break;
      case SubjectsConstants.SPAGNOLO:
        return SvgPicture.asset(
          "assets/icons/subjects/lingue.svg",
        );
        break;
      case SubjectsConstants.RUSSO:
        return SvgPicture.asset(
          "assets/icons/subjects/lingue.svg",
        );
        break;
      case SubjectsConstants.CINESE:
        return SvgPicture.asset(
          "assets/icons/subjects/lingue.svg",
        );
        break;
      case SubjectsConstants.TEDESCO:
        return SvgPicture.asset(
          "assets/icons/subjects/lingue.svg",
        );
        break;
      case SubjectsConstants.DISEGNO_TECNICO:
        return SvgPicture.asset(
          "assets/icons/subjects/disegno_tecnico.svg",
        );
        break;
      case SubjectsConstants.DIRITTO:
        return SvgPicture.asset(
          "assets/icons/subjects/diritto.svg",
        );
        break;
      default:
        return SvgPicture.asset(
          "assets/icons/book_red_lines.svg",
        );
    }
  }

  /// This function returns the color of a grade, it checks if it is because grades
  /// that are null are stored in the database with -1 value, so if it is -1 it must be
  /// canelled or
  static MaterialColor getColorFromGrade(double grade) {
    if (grade >= 6) {
      return Colors.green;
    } else if (grade >= 5.5 && grade < 6) {
      return Colors.yellow;
    } else if (grade == -1) {
      return Colors.blue;
    } else {
      return Colors.red;
    }
  }
}
