import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:f_logs/f_logs.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:registro_elettronico/core/error/failures.dart';
import 'package:registro_elettronico/domain/entity/last_year_token.dart';
import 'package:registro_elettronico/domain/entity/login_token.dart';
import 'package:registro_elettronico/feature/scrutini/domain/repository/scrutini_repository.dart';

import './bloc.dart';

class TokenBloc extends Bloc<TokenEvent, TokenState> {
  ScrutiniRepository scrutiniRepository;

  TokenBloc(this.scrutiniRepository);
  LoginToken loginToken;
  LastYearToken lastYearToken;

  @override
  TokenState get initialState => TokenInitial();

  @override
  Stream<TokenState> mapEventToState(
    TokenEvent event,
  ) async* {
    if (event is GetLoginTokenForSchoolReport) {
      yield TokenLoadInProgress();

      if (loginToken != null) {
        FLog.info(text: 'Got token from singleton');
        yield TokenSchoolReportLoadSuccess(
          token: loginToken.token.split(';')[0],
          schoolReport: event.schoolReport,
        );
      } else {
        try {
          final res = await scrutiniRepository.getLoginToken();
          FLog.info(text: 'Got token from Spaggiari');

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
      FLog.info(text: 'Getting login token');
      yield TokenLoadInProgress();

      if (event.lastYear) {
        if (lastYearToken != null) {
          FLog.info(text: 'Got token from singleton');
          yield TokenLoadSuccess(
            token: loginToken.token.split(';')[0],
          );
        } else {
          final res = await scrutiniRepository.getLoginToken(lastYear: true);
          FLog.info(text: 'Got token from Spaggiari');
          yield* res.fold((failure) async* {
            FLog.error(
              text: 'Error getting token from spaggiari',
            );
            FirebaseCrashlytics.instance
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
          FLog.info(text: 'Got token from singleton');
          yield TokenLoadSuccess(
            token: loginToken.token.split(';')[0],
          );
        } else {
          final res = await scrutiniRepository.getLoginToken();
          FLog.info(text: 'Got token from Spaggiari');
          yield* res.fold((failure) async* {
            FLog.error(
              text: 'Error getting token from spaggiari',
            );
            FirebaseCrashlytics.instance
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
