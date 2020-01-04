import 'dart:core';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:injector/injector.dart';
import 'package:registro_elettronico/data/db/dao/period_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/ui/global/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/constants/subjects_constants.dart';
import 'package:registro_elettronico/utils/constants/tabs_constants.dart';
import 'package:tuple/tuple.dart';

import 'constants/registro_constants.dart';

class GlobalUtils {
  /// This method thakes a list of lessons and returns the lesson [grouped]
  /// checking the lesson argument and the subject id just in case
  static List<Lesson> getGroupedLessonsList(List<Lesson> lessons) {
    List<Lesson> lessonsList = [];
    int count = 1;
    for (var i = 0; i < lessons.length - 1; i++) {
      if (i == lessons.length - 1) {
        if (lessons[i - 1].lessonArg == lessons[i].lessonArg &&
            lessons[i - 1].subjectId == lessons[i].subjectId) {
          lessonsList.add(lessons[i].copyWith(duration: ++count));
        }
      }
      if (lessons[i].lessonArg == lessons[i + 1].lessonArg &&
          lessons[i].subjectId == lessons[i + 1].subjectId) {
        count++;
      } else {
        lessonsList.add(lessons[i].copyWith(duration: count));
        count = 1;
      }
    }
    lessonsList.add(lessons[lessons.length - 1]);
    return lessonsList;
  }

  static Map<Tuple2<int, String>, int> getGroupedLessonsMap(
      List<Lesson> lessons) {
    final Map<Tuple2<int, String>, int> lessonsMap = Map.fromIterable(
      lessons,
      key: (e) => Tuple2<int, String>(e.subjectId, e.lessonArg),
      value: (e) => lessons
          .where(
            (entry) =>
                entry.lessonArg == e.lessonArg &&
                entry.subjectId == e.subjectId,
          )
          .length,
    );
    return lessonsMap;
  }

  static Future<Period> getPeriodFromDate(DateTime date) async {
    final now = DateTime.now();
    final PeriodDao periodDao = PeriodDao(Injector.appInstance.getDependency());
    final periods = await periodDao.getAllPeriods();
    periods.forEach((period) {
      if (period.start.isAfter(now) && period.end.isBefore(now)) return period;
    });
    return null;
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
    // int possibleReduce = subjectTitle.length - 20;
    // possibleReduce > 0
    //     ? possibleReduce = 20 - possibleReduce
    //     : possibleReduce *= -1;
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
        return Colors.green;
        break;
      case 4:
        return Colors.teal;
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
  static Color getColorFromGrade(Grade grade) {
    if (grade.cancelled ||
        grade.decimalValue == -1.00 ||
        grade.localllyCancelled) {
      return Colors.blue;
    } else if (grade.decimalValue >= 6) {
      return Colors.green;
    } else if (grade.decimalValue >= 5.5 && grade.decimalValue < 6) {
      return Colors.yellow[700];
    } else {
      return Colors.red;
    }
  }

  static Color getColorFromAverage(double value) {
    if (value == -1.00 || value.isNaN) {
      return Colors.blue;
    } else if (value >= 6) {
      return Colors.green;
    } else if (value >= 5.5 && value < 6) {
      return Colors.yellow[700];
    } else {
      return Colors.red;
    }
  }

  static Color getColorFromAverageAndObjective(double value, int objective) {
    if (value == -1.00 || value.isNaN) {
      return Colors.blue;
    } else if (value >= objective) {
      return Colors.green;
    } else if (value >= 5.5 && value < 6) {
      return Colors.yellow[700];
    } else if (value < 5) {
      return Colors.red;
    } else {
      return Colors.lightGreen;
    }
  }

  //// static String getPeriodName(int index, BuildContext context) {
  ////   return "$index° ${AppLocalizations.of(context).translate('term').toUpperCase()}";
  //// }

  static String getPeriodName(int index, BuildContext context) {
    final trans = AppLocalizations.of(context);
    if (index == TabsConstants.GENERALE)
      return trans.translate('general');
    else
      return '$index ${AppLocalizations.of(context).translate('term')}';
  }

  static int getRandomNumber() {
    Random random = new Random();
    int randomNumber = random.nextInt(99999);
    return randomNumber;
  }

  // static void initialFetch(BuildContext context) {
  //   BlocProvider.of<LessonsBloc>(context).add(UpdateTodayLessons());
  //   BlocProvider.of<AgendaBloc>(context).add(FetchAgenda());
  //   BlocProvider.of<SubjectsBloc>(context).add(UpdateSubjects());
  //   BlocProvider.of<GradesBloc>(context).add(FetchGrades());
  //   BlocProvider.of<PeriodsBloc>(context).add(FetchPeriods());
  // }
}
