import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:registro_elettronico/core/infrastructure/log/logger.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:meta/meta.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/data/model/last_year_token.dart';
import 'package:registro_elettronico/core/data/model/login_token.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures.dart';
import 'package:registro_elettronico/feature/scrutini/domain/repository/scrutini_repository.dart';

part 'token_event.dart';
part 'token_state.dart';

class TokenBloc extends Bloc<TokenEvent, TokenState> {
  final ScrutiniRepository? scrutiniRepository;

  TokenBloc({
    required this.scrutiniRepository,
  }) : super(TokenInitial());

  LoginToken? loginToken;
  LastYearToken? lastYearToken;

  @override
  Stream<TokenState> mapEventToState(
    TokenEvent event,
  ) async* {
    if (event is GetLoginTokenForSchoolReport) {
      yield TokenLoadInProgress();

      if (loginToken != null) {
        Fimber.i('Got token from singleton');
        yield TokenSchoolReportLoadSuccess(
          token: loginToken!.token.split(';')[0],
          schoolReport: event.schoolReport,
        );
      } else {
        try {
          final res = await scrutiniRepository!.getLoginToken();
          Fimber.i('Got token from Spaggiari');

          yield* res.fold((failure) async* {
            yield TokenLoadError();
          }, (token) async* {
            loginToken = LoginToken(token);
            yield TokenSchoolReportLoadSuccess(
              token: token.split(';')[0],
              schoolReport: event.schoolReport,
            );
          });
        } on NotConntectedException {
          yield TokenLoadNotConnected();
        }
      }
    } else if (event is GetLoginToken) {
      Fimber.i('Getting login token');
      yield TokenLoadInProgress();

      if (event.lastYear) {
        if (lastYearToken != null) {
          Fimber.i('Got token from singleton');
          yield TokenLoadSuccess(
            token: loginToken!.token.split(';')[0],
          );
        } else {
          final res = await scrutiniRepository!.getLoginToken(lastYear: true);
          Fimber.i('Got token from Spaggiari');
          yield* res.fold((failure) async* {
            Logger.e(
              text: 'Error getting token from spaggiari',
            );
            await FirebaseCrashlytics.instance
                .log('Error getting token from spaggiari');
            yield TokenLoadError();
          }, (token) async* {
            loginToken = LoginToken(token);
            yield TokenLoadSuccess(
              token: token.split(';')[0],
            );
          });
        }
      } else {
        if (loginToken != null) {
          Fimber.i('Got token from singleton');
          yield TokenLoadSuccess(
            token: loginToken!.token.split(';')[0],
          );
        } else {
          final res = await scrutiniRepository!.getLoginToken();
          Fimber.i('Got token from Spaggiari');
          yield* res.fold((failure) async* {
            Logger.e(
              text: 'Error getting token from spaggiari',
            );
            await FirebaseCrashlytics.instance
                .log('Error getting token from spaggiari');
            yield TokenLoadError();
          }, (token) async* {
            loginToken = LoginToken(token);
            yield TokenLoadSuccess(
              token: token.split(';')[0],
            );
          });
        }
      }
    }
  }
}
