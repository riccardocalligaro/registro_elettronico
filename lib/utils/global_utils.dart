import 'dart:core';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/infrastructure/app_injection.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/feature/periods/data/dao/period_dao.dart';
import 'package:registro_elettronico/utils/constants/subjects_constants.dart';
import 'package:registro_elettronico/utils/constants/tabs_constants.dart';
import 'package:registro_elettronico/utils/date_utils.dart';
import 'package:tuple/tuple.dart';

import 'constants/registro_constants.dart';
import 'constants/subjects_constants.dart';

class GlobalUtils {
  // static void getNotificationBrightness(BuildContext context) {
  //   final brightness = Theme.of(context).brightness;
  //   if(brightness == Brightness.dark) {
  //   }
  // }
  static Profile getMockProfile() {
    return Profile(
      ident: '32',
      firstName: 'x',
      lastName: '',
      release: DateTime.now(),
      token: '',
      studentId: '',
      expire: DateTime.now(),
    );
  }

  static String getColorCode(Color color) {
    return color.value.toString();
  }

  static String getLastUpdateMessage(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    final trans = AppLocalizations.of(context);

    if (difference.inSeconds < 30) {
      return trans.translate('update_now');
    } else if (difference.inSeconds < 60) {
      return trans.translate('update_while_ago');
    } else if (difference.inMinutes == 0) {
      return trans
          .translate('update_seconds')
          .replaceAll('{s}', difference.inSeconds.toString());
    } else if (difference.inMinutes == 1) {
      return trans
          .translate('update_minute')
          .replaceAll('{m}', difference.inMinutes.toString());
    } else if (difference.inHours == 0) {
      return trans
          .translate('update_minutes')
          .replaceAll('{m}', difference.inMinutes.toString());
    } else if (difference.inDays == 0) {
      return trans
          .translate('update_hours')
          .replaceAll('{h}', difference.inHours.toString());
    } else if (difference.inDays == 1) {
      return trans.translate('update_yesterday');
    } else if (difference.inDays > 1 && difference.inDays < 7) {
      return trans
          .translate('update_days')
          .replaceAll('{d}', difference.inDays.toString());
    } else if (difference.inDays == 7) {
      return trans.translate('update_week');
    } else if (difference.inDays > 31) {
      return trans
          .translate('update_days')
          .replaceAll('{d}', (difference.inDays / 30).toStringAsFixed(0));
    } else {
      return trans
          .translate('update_days')
          .replaceAll('{d}', difference.inDays.toString());
    }
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
    List<Lesson> lessons,
  ) {
    final Map<Tuple2<int, String>, int> lessonsMap = Map.fromIterable(
      lessons,
      key: (e) => Tuple2<int, String>(
        e.subjectId,
        e.lessonArg,
      ),
      value: (e) => lessons
          .where(
            (entry) =>
                entry.lessonArg == e.lessonArg &&
                entry.subjectId == e.subjectId &&
                entry.author == e.author,
          )
          .length,
    );
    return lessonsMap;
  }

  static Future<Period> getPeriodFromDate(DateTime date) async {
    final PeriodDao periodDao = PeriodDao(sl());
    final periods = await periodDao.getAllPeriods();
    for (var i = 0; i < periods.length; i++) {
      if (periods[i].start.isBefore(date) && periods[i].end.isAfter(date)) {
        return periods[i];
      }
    }
    if (periods.isNotEmpty) {
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
    if (stringToCompare.contains(RegExp(r'(INGLESE|STRANIERA)'))) {
      return SubjectsConstants.INGLESE;
    }
    if (stringToCompare.contains(RegExp(r'(ITALIANA|ITALIANO)'))) {
      return SubjectsConstants.ITALIANO;
    }
    if (stringToCompare.contains(RegExp(
        r'(TECNOLOGIE E PROGETTAZIONE DI SISTEMI INFORMATICI E DI TELECOMUNICAZIONI)'))) {
      return SubjectsConstants.TPSIT;
    }
    if (stringToCompare.contains(RegExp(r'(GINNASTICA|SCIENZE MOTORIE)'))) {
      return SubjectsConstants.GINNASTICA;
    }
    if (stringToCompare
        .contains(RegExp(r'(INFORMATICA|SCIENZE TECNOLOGIE APPLICATE)'))) {
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
        r'(LINGUA STRANIERA|RUSSO|CINESE|TEDESCO|TEDESCA|SPAGNOLO|FRANCESE)'))) {
      return SubjectsConstants.LINGUE;
    }
    if (stringToCompare.contains(RegExp(r'(ELETTRONICA)'))) {
      return SubjectsConstants.ELETTRONICA;
    }
    if (stringToCompare.contains(RegExp(r'(ARTE)'))) {
      return SubjectsConstants.ARTE;
    }
    if (stringToCompare
        .contains(RegExp(r'(DISEGNO TECNICO|TECNICHE|GRAFICHE|GRAFICA)'))) {
      return SubjectsConstants.DISEGNO_TECNICO;
    }
    if (stringToCompare.contains(RegExp(r'(BIOLOGIA)'))) {
      return SubjectsConstants.BIOLOGIA;
    } else {
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
        break;
      case SubjectsConstants.ITALIANO:
        return "ITALIANO";
        break;
      case SubjectsConstants.RELIGIONE:
        return "RELIGIONE";
        break;
      case SubjectsConstants.INGLESE:
        return "INGLESE";
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
    if (name == RegistroConstants.SOSTEGNO_FULL) return true;
    return false;
  }

  static String reduceSubjectGridTitle(String subjectName) {
    try {
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
    } catch (_) {
      return subjectName;
    }
  }

  static String reduceSubjectTitle(String subjectTitle) {
    try {
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
    } catch (_) {
      return subjectTitle;
    }
  }

  static String reduceSubjectTitleWithLength(String subjectTitle, int length) {
    try {
      String reducedName;
      final subjId = getSubjectConstFromName(subjectTitle);
      reducedName = translateSubject(subjId);
      if (reducedName != "") {
        return reducedName;
      } else {
        if (length < subjectTitle.length) {
          reducedName = subjectTitle.substring(0, length - 1);
          reducedName += "...";
        }
        return reducedName;
      }
    } catch (_) {
      return subjectTitle;
    }
  }

  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static String reduceLessonArgument(String argument) {
    try {
      String reducedName = argument.substring(0, 25);
      reducedName += "...";
      return reducedName;
    } catch (_) {
      return argument;
    }
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
  /// canelled or an annotation
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

  static String getPeriodName(int index, BuildContext context) {
    final trans = AppLocalizations.of(context);
    if (index == TabsConstants.GENERALE) {
      return trans.translate('general');
    } else {
      return '$index ${AppLocalizations.of(context).translate('term')}';
    }
  }

  static int getRandomNumber() {
    Random random = Random();
    int randomNumber = random.nextInt(999999);
    return randomNumber;
  }

  static int getSmallRandomNumber() {
    Random random = Random();
    int randomNumber = random.nextInt(10000);
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
        event.contains('interrogazione') ||
        event.contains('interrogazioni') ||
        event.contains('prova scritta') ||
        event.contains('prova orale') ||
        event.contains('contrôle') ||
        event.contains('esame') ||
        event.contains('examen') ||
        event.contains('debito') ||
        event.contains('test'));
  }

  /// `venerdi alla 4 ora`
  /// `friday at the 4 hour`
  static String getEventDateMessage(
      BuildContext context, DateTime date, bool isFullDay) {
    String dateString = DateUtils.convertDateLocaleDashboard(
        date, AppLocalizations.of(context).locale.toString());

    final Duration diff = date.difference(DateTime.now());

    if (diff.inDays == 0) {
      dateString =
          AppLocalizations.of(context).translate('tomorrow').toLowerCase();

      if (isFullDay) {
        return '${AppLocalizations.of(context).translate('tomorrow').toLowerCase()} ${AppLocalizations.of(context).translate('all_day').toLowerCase()}';
      }
      return AppLocalizations.of(context)
          .translate('tomorrow_at')
          .replaceAll(
            '{hour}',
            date.hour.toString(),
          )
          .toLowerCase();
    }

    if (isFullDay) {
      return '$dateString ${AppLocalizations.of(context).translate('all_day').toLowerCase()}';
    }

    if (diff.inDays == 1) {
      return AppLocalizations.of(context)
          .translate('event_hour_day_single')
          .replaceAll('{date}', dateString)
          .replaceAll(
            '{hour}',
            date.hour.toString(),
          )
          .replaceAll(
            '{day}',
            diff.inDays.toString(),
          );
    }
    return AppLocalizations.of(context)
        .translate('event_hour_day')
        .replaceAll('{date}', dateString)
        .replaceAll(
          '{hour}',
          date.hour.toString(),
        )
        .replaceAll(
          '{days}',
          diff.inDays.toString(),
        );
  }

  static String getMockupName({int index}) {
    final List<String> names = [
      'Anna Maria Panicucci',
      'Licia Zito',
      'Cristiano Capon',
      'Vittoria Bianchi',
      'Prisco Capon',
      'Danilo Marchesi',
      'Marco Lombardi',
      'Adelia Marcelo',
      'Bettino Donati',
      'Gianni Moretti',
      'Rita Parisi',
      'Vinicio Bellini',
      'Filomena Longo',
      'Fiorenzo Bianco',
      'Leone Basile'
    ];

    if (index == null) {
      Random random = Random();
      int randomNumber = random.nextInt(names.length - 1);

      return names[randomNumber];
    }

    if (index > names.length - 1) {
      return 'Mario Rossi';
    }

    return names[index];
  }

  static String getAbsenceMessage(BuildContext context, Absence absence) {
    final code = absence.evtCode;
    if (code == RegistroConstants.ASSENZA &&
        absence.isJustified == true &&
        absence.justifReasonDesc.isNotEmpty) {
      return absence.justifReasonDesc;
    } else if (code == RegistroConstants.ASSENZA) {
      return AppLocalizations.of(context).translate('absent_all_day');
    } else if (code == RegistroConstants.RITARDO) {
      return AppLocalizations.of(context)
          .translate('you_entered_at')
          .replaceAll('{hour}', "${absence.evtHPos}°");
    } else if (code == RegistroConstants.RITARDO_BREVE) {
      return AppLocalizations.of(context).translate('little_bit_late');
    } else if (code == RegistroConstants.USCITA) {
      return AppLocalizations.of(context)
          .translate('exit_at_hour')
          .replaceAll('{hour}', "${absence.evtHPos}°");
    } else {
      return AppLocalizations.of(context).translate('unricognised_event');
    }
  }

  static String getAbsenceLetterFromCode(BuildContext context, String code) {
    if (code == RegistroConstants.ASSENZA) {
      return AppLocalizations.of(context).translate('absence')[0];
    } else if (code == RegistroConstants.RITARDO) {
      return AppLocalizations.of(context).translate('late')[0];
    } else if (code == RegistroConstants.RITARDO_BREVE) {
      return AppLocalizations.of(context).translate('rb_code');
    } else if (code == RegistroConstants.USCITA) {
      return AppLocalizations.of(context).translate('early_exit')[0];
    } else {
      return AppLocalizations.of(context).translate('unricognised_event')[0];
    }
  }

  static String getDateOfAbsence(
      BuildContext context, int days, Absence absence) {
    if (days > 1) {
      final startDateOfAbsence =
          absence.evtDate.subtract(Duration(days: days - 1));
      if (startDateOfAbsence.month != absence.evtDate.month) {
        return "${startDateOfAbsence.day}/${startDateOfAbsence.month} to ${absence.evtDate.day}";
      } else {
        final from = AppLocalizations.of(context).translate('from_absences');
        final to = AppLocalizations.of(context).translate('to_absences');
        return "$from ${startDateOfAbsence.day} $to ${absence.evtDate.day} ${DateUtils.convertMonthLocale(absence.evtDate, AppLocalizations.of(context).locale.toString())}";
      }
    }
    return DateUtils.convertDateLocale(
        absence.evtDate, AppLocalizations.of(context).locale.toString());
  }
}
