import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GlobalUtils {
  static String tryToReduceName(String subjectName) {
    final stringToCompare = subjectName.toUpperCase();
    // todo: maybe convert this to a int with costants
    print(stringToCompare);
    switch (stringToCompare) {
      case "MATEMATICA E COMPLEMENTI DI MATEMATICA":
        return "MATEMATICA";
        break;
      case "RELIGIONE CATTOLICA / ATTIVITA ALTERNATIVA":
        return "RELIGIONE";
        break;
      case "LINGUA INGLESE":
        return "INGLESE";
        break;
      case "TECNOLOGIE E PROGETTAZIONE DI SISTEMI INFORMATICI E DI TELECOMUNICAZIONI":
        return "TPSIT";
        break;
      case "LINGUA E LETTERATURA ITALIANA":
        return "ITALIANO";
        break;
      case "LINGUA E LETTERATURA ITALIANA":
        return "ITALIANO";
        break;
      case "SCIENZE MOTORIE E SPORTIVE":
        return "GINNASTICA";
        break;
      default:
        return "";
    }
  }

  static String reduceSubjectGridTitle(String subjectName) {
    String reducedName;
    reducedName = tryToReduceName(subjectName);
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
    reducedName = tryToReduceName(subjectTitle);
    if (reducedName != "") {
      return reducedName;
    } else {
      reducedName = subjectTitle.substring(0, 20);
      reducedName += "...";
      return reducedName;
    }
  }

  static String reduceLessonArgument(String argument) {
    String reducedName = argument.substring(0, 30);
    reducedName += "...";
    return reducedName;
  }

  static Color generateRandomColor() {
    return Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0)
        .withOpacity(1.0);
  }

  static Color getColorFromPosition(int position) {
    // TODO: generate more colors, 10 - 15
    // TODO: need to set a subject color in the database
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

  static SvgPicture getIconFromSubject(String subject) {
    subject = subject.toLowerCase().replaceAll(" ", "");
    switch (subject) {
      case "matematicaecomplementidimatematica":
        return SvgPicture.asset(
          "assets/icons/science-symbol.svg",
        );
        break;
      default:
        return SvgPicture.asset(
          "assets/icons/book_red_lines.svg",
        );
    }
  }
}
