part of 'token_bloc.dart';

@immutable
abstract class TokenEvent {}

class GetLoginTokenForSchoolReport extends TokenEvent {
  final SchoolReport schoolReport;

  GetLoginTokenForSchoolReport({
    required this.schoolReport,
  });
}

class GetLoginToken extends TokenEvent {
  final bool lastYear;

  GetLoginToken(this.lastYear);
}
