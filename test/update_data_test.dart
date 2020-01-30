import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Getting new vital data', () {
    final today = DateTime.now();

    bool updateData(DateTime lastUpdate) {
      final now = DateTime.now();
      int yearBegin = now.year;

      // if we are before sempember we need to fetch from the last year
      if (now.month < DateTime.september) {
        yearBegin -= 1;
      }

      final DateTime beginDate = DateTime.utc(yearBegin, DateTime.september, 1);

      return lastUpdate.isBefore(beginDate);
    }

    test('update subjects data', () {
      // Last update
      final august = DateTime.utc(2019, 08, 11);

      final augustLastYear = DateTime.utc(2018, 08, 11);

      final augustLastDat = DateTime.utc(2019, 08, 31);

      expect(true, updateData(august));

      expect(true, updateData(augustLastYear));

      expect(true, updateData(augustLastDat));
    });

    test('dont update subjects data', () {
      final januaryNewYear = DateTime.utc(2020, 11, 1);

      final september = DateTime.utc(2019, 09, 1);

      final septemberNewYear = DateTime.utc(2020, 09, 1);

      final december = DateTime.utc(2019, 12, 1);

      expect(false, updateData(januaryNewYear));

      expect(false, updateData(september));

      expect(false, updateData(december));

      expect(false, updateData(septemberNewYear));
    });

    test('updating data', () {
      final august = DateTime.utc(2019, 08, 11);
      expect(true, updateData(august));
      // Update data
      final lastUpdate = DateTime.now();
      expect(false, updateData(lastUpdate));
    });
  });
}
