import 'package:meta/meta.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';

@immutable
abstract class TokenEvent {}

class GetLoginToken extends TokenEvent {
  final String viewUrl;
  final SchoolReport schoolReport;

  GetLoginToken({
    @required this.viewUrl,
    @required this.schoolReport,
  });
}
