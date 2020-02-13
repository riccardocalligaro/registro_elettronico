import 'package:meta/meta.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';

@immutable
abstract class TokenEvent {}

class GetLoginTokenForSchoolReport extends TokenEvent {
  final SchoolReport schoolReport;

  GetLoginTokenForSchoolReport({
    @required this.schoolReport,
  });
}

class GetLoginToken extends TokenEvent {
  final bool lastYear;
  GetLoginToken(this.lastYear);
}
