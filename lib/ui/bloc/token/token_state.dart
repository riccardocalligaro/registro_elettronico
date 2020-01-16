import 'package:meta/meta.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';

@immutable
abstract class TokenState {}

class TokenInitial extends TokenState {}

class TokenLoadInProgress extends TokenState {}

class TokenSchoolReportLoadSuccess extends TokenState {
  final String token;
  final SchoolReport schoolReport;

  TokenSchoolReportLoadSuccess({
    @required this.token,
    @required this.schoolReport,
  });
}

class TokenLoadSuccess extends TokenState {
  final String token;

  TokenLoadSuccess({
    @required this.token,
  });
}

class TokenLoadError extends TokenState {}
