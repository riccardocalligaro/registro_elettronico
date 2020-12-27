import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/utils/entity/datetime_interval.dart';
import 'package:tuple/tuple.dart';

class DateUtils {
  /// Gives the date in the format [yyyyMMdd], no locale ->
  /// [Date]: 20191113
  static String convertDate(DateTime date) {
    final formatter = DateFormat('yyyyMMdd');
    return formatter.format(date);
  }

  /// Gives the date in the format [dd MMMM yyyy], no locale
  /// [Date]: 07 January 2020
  static String convertDateForLessons(DateTime date) {
    final formatter = DateFormat("dd MMMM yyyy");
    return formatter.format(date);
  }

  /// Gives the date in the format [dd MMMM yy], no locale
  /// [Date]: 07 January 20
  static String convertDateForDisplay(DateTime date) {
    final formatter = DateFormat('dd MMMM yy');
    return formatter.format(date);
  }

  static String convertMonthForDisplay(DateTime date, String locale) {
    final formatter = DateFormat.MMM(locale);
    return formatter.format(date);
  }

  /// [Hm] format
  static String convertTimeForDisplay(DateTime date, String locale) {
    final formatter = DateFormat.Hm(locale);
    return formatter.format(date);
  }

  static String convertSingleDayForDisplay(DateTime date, String locale) {
    final formatter = DateFormat.EEEE(locale);
    return formatter.format(date);
  }

  static String convertSingleDayShortForDisplay(DateTime date, String locale) {
    final formatter = DateFormat.E(locale);
    return formatter.format(date);
  }

  static String convertMonthLocale(DateTime date, String locale) {
    final formatter = DateFormat.MMMM(locale);
    return formatter.format(date);
  }

  static String convertDateLocale(DateTime date, String locale) {
    final formatter = DateFormat.yMMMMd(locale);
    return formatter.format(date);
  }

  static String convertDateLocaleDashboard(DateTime date, String locale) {
    final formatter = DateFormat.MMMMEEEEd(locale);
    return formatter.format(date);
  }

  /// Returns [Date] and [Time]
  static Tuple2<String, String> convertDateAndTimeLocale(
      DateTime date, String locale) {
    final formatter = DateFormat.MMMMEEEEd(locale);
    final dateMonth = formatter.format(date);

    final formatterTime = DateFormat.Hm(locale);
    final time = formatterTime.format(date);

    return Tuple2(dateMonth, time);
  }

  static String getNewEventDateMessage(
      DateTime date, String locale, BuildContext context) {
    final formatter = DateFormat.MMMMEEEEd(locale);

    final today = DateTime.now();

    final tomorrow = today.add(Duration(days: 1));

    if (areSameDay(today, date)) {
      return AppLocalizations.of(context).translate('today');
    } else if (areSameDay(tomorrow, date)) {
      return AppLocalizations.of(context).translate('tomorrow');
    } else {
      return formatter.format(date);
    }
  }

  static String getBeforeNotifyTimeMessage(Duration d, BuildContext context) {
    final trans = AppLocalizations.of(context);
    if (d.inMilliseconds == 0) {
      return trans.translate('moment_of_event');
    } else if (d.inMinutes == 1) {
      return trans.translate('minute_before').replaceAll('{m}', '1');
    } else if (d.inMinutes < 60) {
      return trans
          .translate('minutes_before')
          .replaceAll('{m}', d.inMinutes.toString());
    } else if (d.inHours < 24) {
      if (d.inHours == 1) {
        return trans.translate('hour_before').replaceAll('{m}', '1');
      }
      return trans
          .translate('hours_before')
          .replaceAll('{m}', d.inHours.toString());
    } else {
      return trans.translate('one_day_before');
    }
  }

  /// The spaggiari API returns the date in the following
  /// format: [20191112], this function converts this [string] into a [date]
  static DateTime getDateFromApiString(String date) {
    final parts = date.split('-');
    return DateTime.utc(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }

  /// This returns the [max interval] to fetch all the lessons / grades
  /// For example if it is november 2019 it fetches => sep 2019 to aug 2020
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

    final begin = convertDate(beginDate);
    final end = convertDate(endDate);

    return DateTimeInterval(begin: begin, end: end);
  }

  /// Given [date1] and [date2] it checks the day and returns
  /// true if are the same number
  static bool areSameDay(DateTime date1, DateTime date2) {
    return date1.day == date2.day &&
        date1.month == date2.month &&
        date1.year == date2.year;
  }
}
