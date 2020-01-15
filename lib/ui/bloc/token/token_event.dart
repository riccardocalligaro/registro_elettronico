import 'package:meta/meta.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';

@immutable
abstract class TokenEvent {}

class GetLoginToken extends TokenEvent {
  final SchoolReport schoolReport;

  GetLoginToken({
    @required this.schoolReport,
  });
}
