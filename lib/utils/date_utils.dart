import 'package:intl/intl.dart';
import 'package:registro_elettronico/utils/entity/datetime_interval.dart';

class DateUtils {
  static String convertDate(DateTime date) {
    final formatter = DateFormat('yyyyMMdd');
    return formatter.format(date);
  }

  static String convertDateForLessons(DateTime date) {
    final formatter = DateFormat("dd MMMM yyyy");
    return formatter.format(date);
  }

  static String convertDateForDisplay(DateTime date) {
    final formatter = DateFormat('dd MMMM yy');
    return formatter.format(date);
  }

  static DateTime getDateFromApiString(String date) {
    final parts = date.split('-');
    return DateTime.utc(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
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

    final begin = convertDate(beginDate);
    final end = convertDate(endDate);

    return DateTimeInterval(begin: begin, end: end);
  }

  static bool areSameDay(DateTime date1, DateTime date2) {
    return date1.day == date2.day &&
        date1.month == date2.month &&
        date1.year == date2.year;
  }
}
