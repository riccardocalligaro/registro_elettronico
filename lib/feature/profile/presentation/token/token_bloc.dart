import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:meta/meta.dart';
import 'package:registro_elettronico/core/error/failures.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/data/model/last_year_token.dart';
import 'package:registro_elettronico/domain/entity/login_token.dart';
import 'package:registro_elettronico/feature/scrutini/domain/repository/scrutini_repository.dart';

part 'token_event.dart';

part 'token_state.dart';

class TokenBloc extends Bloc<TokenEvent, TokenState> {
  final ScrutiniRepository scrutiniRepository;

  TokenBloc({
    @required this.scrutiniRepository,
  }) : super(TokenInitial());

  LoginToken loginToken;
  LastYearToken lastYearToken;

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
