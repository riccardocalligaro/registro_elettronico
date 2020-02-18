import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:registro_elettronico/utils/date_utils.dart';

void main() {
  group('Test notifications date', () {
    var date = DateTime.utc(2020, 02, 11);
    initializeDateFormatting('it_IT');
    final String converted = DateUtils.convertDateLocale(date, 'it_IT');
    test('convert date for notificaitons', () {
      expect('11 febbraio 2020', converted);
    });
  });
}
