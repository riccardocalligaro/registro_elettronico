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
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:tuple/tuple.dart';

import 'constants/registro_constants.dart';
import 'constants/subjects_constants.dart';

class GlobalUtils {
  static Profile getMockProfile() {
    return Profile(
      id: -1,
      ident: '32',
      firstName: 'x',
      lastName: '',
      release: DateTime.now(),
      passwordKey: '',
      token: '',
      studentId: '',
      expire: DateTime.now(),
    );
  }

  static String getLastUpdateMessage(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 30) return "Now";
    if (difference.inMinutes == 0) return "${difference.inSeconds} seconds ago";
    if (difference.inMinutes == 1) return "${difference.inMinutes} minute ago";
    if (difference.inHours == 0) return "${difference.inMinutes} minutes ago";
    if (difference.inDays == 0) return "${difference.inHours} hours ago";
    if (difference.inDays == 1) return "Yesterday";
    if (difference.inDays > 1 && difference.inDays < 7)
      return "${difference.inDays} days ago";
    if (difference.inDays == 7) return "A week ago";
    if (difference.inDays > 31) {
      return (difference.inDays / 30).toStringAsFixed(0);
    } else
      return "${difference.inDays} days ago";
  }

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
          .where((entry) =>
              entry.lessonArg == e.lessonArg &&
              entry.subjectId == e.subjectId &&
              entry.author == e.author)
          .length,
    );
    return lessonsMap;
  }

  static Future<Period> getPeriodFromDate(DateTime date) async {
    final PeriodDao periodDao = PeriodDao(Injector.appInstance.getDependency());
    final periods = await periodDao.getAllPeriods();
    for (var i = 0; i < periods.length; i++) {
      if (periods[i].start.isBefore(date) && periods[i].end.isAfter(date))
        return periods[i];
    }
    if (periods.length > 0) {
      int closestIndex = 0;
      int minDays = 366;
      for (var i = 0; i < periods.length; i++) {
        int diff = date.difference(periods[i].end).inDays;
        if (diff < minDays) {
          minDays = diff;
          closestIndex = i;
        }
      }
      return periods[closestIndex];
    }

    return null;
  }

  static int getSubjectConstFromName(String subjectName) {
    final stringToCompare = subjectName.toUpperCase();
    if (stringToCompare.contains(RegExp(r'(MATEMATICA)'))) {
      return SubjectsConstants.MATEMATICA;
    }
    if (stringToCompare.contains(RegExp(r'(RELIGIONE|ALTERNATIVA)'))) {
      return SubjectsConstants.RELIGIONE;
    }
    if (stringToCompare.contains("INGLESE")) {
      return SubjectsConstants.INGLESE;
    }
    if (stringToCompare.contains(RegExp(r'(ITALIANA|ITALIANO)'))) {
      return SubjectsConstants.ITALIANO;
    }
    if (stringToCompare.contains(RegExp(
        r'("TECNOLOGIE E PROGETTAZIONE DI SISTEMI INFORMATICI E DI TELECOMUNICAZIONI")'))) {
      return SubjectsConstants.TPSIT;
    }
    if (stringToCompare.contains(RegExp(r'(GINNASTICA|"SCIENZE MOTORIE")'))) {
      return SubjectsConstants.GINNASTICA;
    }
    if (stringToCompare
        .contains(RegExp(r'(INFORMATICA|"SCIENZE TECNOLOGIE APPLICATE")'))) {
      return SubjectsConstants.INFORMATICA;
    }
    if (stringToCompare.contains(RegExp(r'(TELECOMUNICAZIONI)'))) {
      return SubjectsConstants.TELECOMUNICAZIONI;
    }
    if (stringToCompare.contains(RegExp(r'(GEOGRAFIA)'))) {
      return SubjectsConstants.GEOGRAFIA;
    }
    if (stringToCompare.contains(RegExp(r'(DIRITTO)'))) {
      return SubjectsConstants.DIRITTO;
    }
    if (stringToCompare.contains(RegExp(r'(CHIMICA)'))) {
      return SubjectsConstants.CHIMICA;
    }
    if (stringToCompare.contains(RegExp(
        r'("LINGUA STRANIERA"|RUSSO|CINESE|TEDESCO|TEDESCA|SPAGNOLO|FRANCESE)'))) {
      return SubjectsConstants.LINGUE;
    }
    if (stringToCompare.contains(RegExp(r'(ELETTRONICA)'))) {
      return SubjectsConstants.ELETTRONICA;
    }
    if (stringToCompare.contains(RegExp(r'(ARTE)'))) {
      return SubjectsConstants.ARTE;
    }
    if (stringToCompare
        .contains(RegExp(r'("DISEGNO TECNICO"|TECNICHE|GRAFICHE|GRAFICA)'))) {
      return SubjectsConstants.DISEGNO_TECNICO;
    }
    if (stringToCompare.contains(RegExp(r'(BIOLOGIA)'))) {
      return SubjectsConstants.BIOLOGIA;
    } else
      return -1;
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

  static String reduceSubjectTitleWithLength(String subjectTitle, int length) {
    String reducedName;
    final subjId = getSubjectConstFromName(subjectTitle);

    reducedName = translateSubject(subjId);
    if (reducedName != "") {
      return reducedName;
    } else {
      reducedName = subjectTitle.substring(0, length);
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
      case SubjectsConstants.LINGUE:
        return SvgPicture.asset("assets/icons/subjects/lingue.svg");
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
      case SubjectsConstants.GINNASTICA:
        return SvgPicture.asset(
          "assets/icons/subjects/barbell.svg",
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

  static bool isCompito(String event) {
    event = event.toLowerCase();
    return (event.contains('compiti') ||
        event.contains('consegna') ||
        event.contains('consegnare'));
  }

  static bool isVerificaOrInterrogazione(String event) {
    event = event.toLowerCase();
    return (event.contains('compito') ||
        event.contains('verifica') ||
        event.contains('interrogazione'));
  }

  /// `venerdi alla 4 ora`
  /// `friday at the 4 hour`
  static String getEventDateMessage(BuildContext context, DateTime date) {
    final String dateString = DateUtils.convertDateLocale(
        date, AppLocalizations.of(context).locale.toString());
    return AppLocalizations.of(context)
        .translate('event_hour_day')
        .replaceAll('{date}', dateString)
        .replaceAll('{hour}', date.hour.toString());
  }

  // static void initialFetch(BuildContext context) {
  //   BlocProvider.of<LessonsBloc>(context).add(UpdateTodayLessons());
  //   BlocProvider.of<AgendaBloc>(context).add(FetchAgenda());
  //   BlocProvider.of<SubjectsBloc>(context).add(UpdateSubjects());
  //   BlocProvider.of<GradesBloc>(context).add(FetchGrades());
  //   BlocProvider.of<PeriodsBloc>(context).add(FetchPeriods());
  // }
}
